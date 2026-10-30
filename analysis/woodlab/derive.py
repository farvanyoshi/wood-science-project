"""Derived physical quantities. Units follow data/README.md."""

G = 9.81                # m/s², converts the gauge reading in metric tonnes to kN
FT_LBF_TO_J = 1.35582   # 1 ft·lbf in joules


def volume_cm3(length_mm: float, width_mm: float, thickness_mm: float) -> float:
    return length_mm * width_mm * thickness_mm / 1000


def density(mass_g: float, volume: float) -> float:
    """g/cm³"""
    return mass_g / volume


def load_kn(gauge_t: float) -> float:
    return gauge_t * G


def modulus_of_rupture(load_kn: float, span_mm: float, width_mm: float, thickness_mm: float) -> float:
    """Three-point bending: σ_r = 3FL / (2wt²), in MPa (N/mm²)."""
    return 3 * (load_kn * 1000) * span_mm / (2 * width_mm * thickness_mm**2)


def strength_to_weight(mor_mpa: float, density_g_cm3: float) -> float:
    """Specific strength in kN·m/kg. 1 MPa / (1 g/cm³) = 1 kN·m/kg."""
    return mor_mpa / density_g_cm3


def derive_segment(row: dict) -> dict:
    out = dict(row)
    out["volume_cm3"] = volume_cm3(row["length_mm"], row["width_mm"], row["thickness_mm"])
    out["density_g_cm3"] = density(row["mass_g"], out["volume_cm3"])
    out["load_kn"] = load_kn(row["gauge_load_t"])
    out["mor_mpa"] = modulus_of_rupture(out["load_kn"], row["span_mm"], row["width_mm"], row["thickness_mm"])
    out["sw_knm_per_kg"] = strength_to_weight(out["mor_mpa"], out["density_g_cm3"])
    return out


def derive_impact(row: dict) -> dict:
    return {**row, "energy_j": row["energy_ftlb"] * FT_LBF_TO_J}
