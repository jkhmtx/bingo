use bpaf::*;

#[derive(Bpaf, Clone, Debug)]
#[bpaf(options)]
pub enum MrxCommand {
    #[bpaf(command)]
    /// Generate the project's barrel Nix file
    Generate,
    #[bpaf(command)]
    /// Print the post-build shell hook
    Hook,

    #[bpaf(command)]
    /// Print some aspect of the mrx configuration or build system to stdout
    Show {
        #[bpaf(long("watch-files"))]
        /// Print watch files for another program to consume.
        /// Watch files are those which are nodes in the dependency graph
        /// determined by the entrypoint.
        watch_files: bool,
    },
}
