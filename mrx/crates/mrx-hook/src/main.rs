use mrx_hook::hook;
use mrx_utils::Config;

fn main() {
    let config = Config::new();
    hook(config);
}
