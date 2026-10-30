"""Checks the pipeline against the original spreadsheet and the values published in the paper."""

import csv
import math
import shutil
import tempfile
import unittest
from pathlib import Path

from woodlab import derive
from woodlab.loaders import DataError
from woodlab.pipeline import build
from woodlab.stats import Summary, linear_fit

REPO = Path(__file__).resolve().parents[2]
RAW = REPO / "data" / "raw"
FIXTURES = Path(__file__).parent / "fixtures"


def read(path):
    with open(path, newline="") as f:
        return list(csv.DictReader(f))


class PipelineTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = Path(tempfile.mkdtemp())
        build(RAW, cls.tmp)
        cls.segments = read(cls.tmp / "segments.csv")
        cls.summary = {(r["quantity"], float(r["level"])): r for r in read(cls.tmp / "summary.csv")}
        cls.fits = {r["name"]: r for r in read(cls.tmp / "fits.csv")}

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.tmp)

    def stat(self, quantity, level, field="mean"):
        return float(self.summary[(quantity, level)][field])

    def test_segments_match_original_spreadsheet(self):
        # The spreadsheet rounded its derived columns to 3 (density, S/W) and 2 (MOR) decimals.
        original = {(int(r["block_id"]), int(r["segment_id"])): r for r in read(FIXTURES / "original_spreadsheet.csv")}
        self.assertEqual(len(self.segments), len(original))
        for seg in self.segments:
            ref = original[(int(seg["block_id"]), int(seg["segment_id"]))]
            self.assertAlmostEqual(float(seg["density_g_cm3"]), float(ref["density_g/cm^3"]), delta=6e-4)
            self.assertAlmostEqual(float(seg["load_kn"]), float(ref["max load_kN"]), delta=6e-3)
            self.assertAlmostEqual(float(seg["mor_mpa"]), float(ref["MOR_MPa"]), delta=0.05)
            self.assertAlmostEqual(float(seg["sw_knm_per_kg"]) / 1000, float(ref["SW"]), delta=1.5e-3)

    def test_published_means_unaffected_by_span_choice(self):
        # Paper Figures: density means and the 3-5 MPa MOR means (spans agree in every source there).
        for p, rho in zip([3, 4, 5, 6, 7], [0.273, 0.529, 0.596, 0.769, 0.544]):
            self.assertAlmostEqual(self.stat("density_g_cm3", p), rho, delta=6e-4)
        for p, mor in zip([3, 4, 5], [60.3, 186, 163]):
            self.assertAlmostEqual(self.stat("mor_mpa", p), mor, delta=0.6)
        self.assertAlmostEqual(self.stat("mor_mpa", 4, "mean_excl"), 137, delta=0.6)
        self.assertAlmostEqual(self.stat("sw_knm_per_kg", 4, "mean_excl"), 264, delta=0.6)

    def test_span_rescales_6_and_7_mpa(self):
        # The paper used 70 mm for 6 and 7 MPa; the spreadsheet (used here) says 60 mm.
        for p, published in [(6, 213), (7, 224)]:
            self.assertAlmostEqual(self.stat("mor_mpa", p) * 70 / 60, published, delta=0.6)
        self.assertAlmostEqual(self.stat("sw_knm_per_kg", 7) * 70 / 60, 410, delta=1)

    def test_outlier_excluded_only_where_listed(self):
        self.assertEqual(self.summary[("mor_mpa", 4)]["n_excl"], "4")
        self.assertEqual(self.summary[("density_g_cm3", 4)]["n_excl"], "5")

    def test_block_masses_match_paper(self):
        for p, m in zip([3, 4, 5, 6, 7], [85.7, 113.2, 100.4, 108.9, 91.0]):
            self.assertAlmostEqual(self.stat("block_mass_g", p), m, delta=0.05)

    def test_impact_matches_paper_joules(self):
        impact = read(self.tmp / "impact.csv")
        published = {5: [3.66, 6.10, 8.81, 5.02], 6: [6.78, 3.39, 4.34, 1.49]}
        for row in impact:
            h = int(float(row["dissolution_h"]))
            if h in published:
                self.assertAlmostEqual(float(row["energy_j"]), published[h][int(row["specimen"]) - 1], delta=6e-3)
        self.assertAlmostEqual(self.stat("impact_j", 5), 5.90, delta=6e-3)
        self.assertAlmostEqual(self.stat("impact_j", 6), 4.00, delta=6e-3)

    def test_fits_match_paper(self):
        s = self.fits["flexural_stiffness"]
        self.assertAlmostEqual(float(s["slope"]), 6.239, delta=5e-4)
        self.assertAlmostEqual(float(s["intercept"]), 1.852, delta=5e-4)
        m = self.fits["flexural_modulus"]
        self.assertAlmostEqual(float(m["slope"]), 5199, delta=0.5)
        self.assertAlmostEqual(float(m["intercept"]), 28.58, delta=5e-3)

    def test_build_is_reproducible(self):
        committed = REPO / "data" / "processed"
        for name in ["segments.csv", "summary.csv", "impact.csv", "fits.csv"]:
            self.assertEqual((self.tmp / name).read_text(), (committed / name).read_text(),
                             f"data/processed/{name} is stale; run `python -m woodlab build`")


class UnitTest(unittest.TestCase):
    def test_summary(self):
        s = Summary.of([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0])
        self.assertEqual(s.n, 8)
        self.assertAlmostEqual(s.mean, 5.0)
        self.assertAlmostEqual(s.sd, math.sqrt(32 / 7))
        self.assertAlmostEqual(s.se, math.sqrt(32 / 7) / math.sqrt(8))

    def test_linear_fit_exact_line(self):
        f = linear_fit([0, 1, 2, 3], [1, 3, 5, 7])
        self.assertAlmostEqual(f.slope, 2)
        self.assertAlmostEqual(f.intercept, 1)
        self.assertAlmostEqual(f.r2, 1)

    def test_modulus_of_rupture(self):
        # 1 kN over a 100 mm span on a 10 mm x 10 mm section: 3*1000*100 / (2*10*100) = 150 MPa
        self.assertAlmostEqual(derive.modulus_of_rupture(1, 100, 10, 10), 150)

    def test_validation_errors(self):
        tmp = Path(tempfile.mkdtemp())
        try:
            shutil.copytree(RAW, tmp / "raw")
            seg = tmp / "raw" / "vc_segments.csv"
            lines = seg.read_text().splitlines()
            lines[1] = lines[1].replace(",60,", ",90,", 1)  # span longer than the 80 mm segment
            seg.write_text("\n".join(lines) + "\n")
            with self.assertRaisesRegex(DataError, "span"):
                build(tmp / "raw", tmp / "out")
            seg.write_text(lines[0].replace("mass_g,", "") + "\n")
            with self.assertRaisesRegex(DataError, "missing column"):
                build(tmp / "raw", tmp / "out")
        finally:
            shutil.rmtree(tmp)


if __name__ == "__main__":
    unittest.main()
