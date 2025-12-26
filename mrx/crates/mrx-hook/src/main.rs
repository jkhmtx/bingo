use mrx_hook::{Options, hook};

fn main() {
    let (config, options) = Options::args().unwrap();
    hook(config, options)
}
