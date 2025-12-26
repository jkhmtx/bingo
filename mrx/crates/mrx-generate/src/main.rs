use mrx_generate::{Options, generate};

fn main() {
    let (config, options) = Options::args().unwrap();
    generate(config, options).unwrap();
}
