use mrx_show::{Options, show};

fn main() {
    let (config, options) = Options::args().unwrap();
    show(config, options);
}
