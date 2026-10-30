"""Descriptive statistics and linear fits."""

from __future__ import annotations

import math
import statistics
from collections import defaultdict
from dataclasses import dataclass


@dataclass(frozen=True)
class Summary:
    n: int
    mean: float
    sd: float
    se: float

    @classmethod
    def of(cls, values: list[float]) -> "Summary":
        if not values:
            raise ValueError("cannot summarise an empty group")
        n = len(values)
        sd = statistics.stdev(values) if n > 1 else 0.0
        return cls(n, statistics.fmean(values), sd, sd / math.sqrt(n))


def group_by(rows: list[dict], key: str) -> dict:
    groups = defaultdict(list)
    for row in rows:
        groups[row[key]].append(row)
    return dict(sorted(groups.items()))


@dataclass(frozen=True)
class Fit:
    slope: float
    intercept: float
    r2: float
    n: int
    x_min: float
    x_max: float


def linear_fit(xs: list[float], ys: list[float]) -> Fit:
    """Ordinary least squares y = slope·x + intercept."""
    if len(xs) != len(ys) or len(xs) < 3:
        raise ValueError("linear_fit needs at least 3 paired points")
    slope, intercept = statistics.linear_regression(xs, ys)
    r = statistics.correlation(xs, ys)
    return Fit(slope, intercept, r * r, len(xs), min(xs), max(xs))
