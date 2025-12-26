use mrx_build::{Options, build};

fn main() {
    let (config, options) = Options::args().unwrap();
    build(config, options).unwrap();
}
