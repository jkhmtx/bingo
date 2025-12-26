use mrx_cache::{Options, cache};

fn main() {
    let (config, options) = Options::args().unwrap();
    cache(config, options).unwrap();
}
