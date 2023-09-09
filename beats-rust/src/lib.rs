use std::f64;

#[no_mangle]
pub extern "C" fn get_base_attack(level: u32) -> i32 {
    let square = f64::sqrt(2.0 * (level as f64) - 1.0 + 2025.0);
    let step_formula = f64::floor((square + 5.0) / 10.0);
    let frac = ((level as f64 + 1000.0) / step_formula) - (50.0 * step_formula);
    let base_form = frac + (100.0 * step_formula) - 450.0;

    base_form.floor() as i32
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = get_base_attack(1100);
        assert_eq!(result, 200);
    }
}
