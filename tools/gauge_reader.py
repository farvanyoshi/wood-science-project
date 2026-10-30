"""Read the peak value of an analog dial gauge from video.

For each video, the first frame is shown for calibration. Click the needle pivot,
then the gauge's zero mark, then a mark of known value, and type that value in
the terminal. Each frame is then thresholded to isolate the (bright) needle. The
point of the needle contour furthest from the pivot is taken as the tip, and its
angle is converted linearly to a reading. The maximum reading per video is reported.

Usage:
    python gauge_reader.py "IMG_*.MOV" --threshold 180 --out readings.csv

Press q while a video is tracking to skip the rest of it.
"""

import argparse
import csv
import glob
import math

import cv2


def get_angle(p1, p2):
    """Angle of the vector p1 -> p2 in degrees, in (-180, 180]."""
    (x1, y1), (x2, y2) = p1, p2
    return math.degrees(math.atan2(y2 - y1, x2 - x1))


def wrap(angle):
    """Wrap an angle difference into [-180, 180]."""
    if angle < -180:
        angle += 360
    if angle > 180:
        angle -= 360
    return angle


def interpolate_value(current_angle, cal):
    """Linear interpolation between the zero mark and the calibration mark."""
    total_span = wrap(cal["angle_cal"] - cal["angle_zero"])
    current_span = wrap(current_angle - cal["angle_zero"])
    return current_span / total_span * cal["cal_val"]


def calibrate(frame, title):
    """Collect pivot, zero and calibration clicks on `frame`; returns the calibration dict."""
    points = []

    def on_click(event, x, y, *_):
        if event == cv2.EVENT_LBUTTONDOWN and len(points) < 3:
            points.append((x, y))
            prompts = ["Center set. Now click the '0' mark.",
                       "Zero set. Now click a mark of known value.",
                       "Calibration point set."]
            print(f"  [Click] ({x}, {y}) {prompts[len(points) - 1]}")

    print("Click the needle pivot, then the zero mark, then a known value.")
    cv2.imshow(title, frame)
    cv2.setMouseCallback(title, on_click)
    while len(points) < 3:
        cv2.waitKey(1)
    cv2.destroyWindow(title)

    value = float(input("Value of the mark clicked for calibration (e.g. 20): "))
    center, zero, known = points
    return {
        "center": center,
        "angle_zero": get_angle(center, zero),
        "angle_cal": get_angle(center, known),
        "cal_val": value,
    }


def find_needle_tip(frame, center, threshold):
    """Return the needle tip (furthest contour point from the pivot), or None if no needle is found."""
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    _, mask = cv2.threshold(gray, threshold, 255, cv2.THRESH_BINARY)
    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    tip, max_dist = None, 0
    for cnt in contours:
        # only consider contours that pass within 20 px of the pivot
        if cv2.pointPolygonTest(cnt, center, True) > -20:
            for point in cnt:
                pt = tuple(int(v) for v in point[0])
                d = math.dist(center, pt)
                if d > max_dist:
                    max_dist, tip = d, pt
    return tip


def track_video(cap, cal, threshold):
    """Return the maximum gauge reading over all remaining frames of `cap`."""
    max_reading = 0
    while True:
        ok, frame = cap.read()
        if not ok:
            break
        tip = find_needle_tip(frame, cal["center"], threshold)
        if tip is not None:
            max_reading = max(max_reading, interpolate_value(get_angle(cal["center"], tip), cal))
        cv2.imshow("Tracking...", frame)
        if cv2.waitKey(1) & 0xFF == ord("q"):
            break
    return max_reading


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("pattern", nargs="?", default="IMG_*.MOV", help="glob pattern of videos (default: IMG_*.MOV)")
    parser.add_argument("--threshold", type=int, default=180, help="grayscale threshold isolating the needle (0-255)")
    parser.add_argument("--out", help="optional CSV file for the results")
    args = parser.parse_args()

    videos = sorted(glob.glob(args.pattern))
    if not videos:
        parser.exit(1, f"No video files match '{args.pattern}'\n")
    print(f"Processing {len(videos)} videos: {videos}")

    results = {}
    cal = None
    for filename in videos:
        cap = cv2.VideoCapture(filename)
        ok, first = cap.read() if cap.isOpened() else (False, None)
        if not ok:
            print(f"Could not read {filename}. Skipping.")
            continue

        if cal is None or input("Reuse previous calibration? (y/n): ").lower() != "y":
            cal = calibrate(first, f"Calibrate: {filename}")

        results[filename] = track_video(cap, cal, args.threshold)
        cap.release()
        cv2.destroyAllWindows()
        print(f"-> Finished {filename}. Max reading: {results[filename]:.2f}")

    print("\n" + "=" * 35)
    print(f"{'Filename':<20} | Max reading")
    print("-" * 35)
    for name, value in results.items():
        print(f"{name:<20} | {value:.4f}")

    if args.out:
        with open(args.out, "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(["video", "max_reading"])
            writer.writerows((name, f"{value:.4f}") for name, value in results.items())
        print(f"Wrote {args.out}")


if __name__ == "__main__":
    main()
