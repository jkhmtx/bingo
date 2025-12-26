use mrx_refresh::{Options, refresh};

fn main() {
    let (config, options) = Options::args().unwrap();
    refresh(config, options);
}
