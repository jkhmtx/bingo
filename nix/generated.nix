{...}: {
  bingo.run = ../bingo/run/main.nix;
  frontend.build = ../frontend/scripts/bin/build/main.nix;
  frontend.dev = ../frontend/scripts/bin/dev/main.nix;
  frontend.preview = ../frontend/scripts/bin/preview/main.nix;
  frontend.yarn = ../frontend/scripts/bin/yarn/main.nix;
  root.check = ../scripts/bin/check/main.nix;
  root.fix = ../scripts/bin/fix/main.nix;
  root.format-nix = ../scripts/bin/format-nix/main.nix;
  root.format = ../scripts/bin/format/main.nix;
  root.format-shell = ../scripts/bin/format-shell/main.nix;
  root.format-yaml = ../scripts/bin/format-yaml/main.nix;
  root.lint-github-actions = ../scripts/bin/lint-github-actions/main.nix;
  root.lint = ../scripts/bin/lint/main.nix;
  root.lint-shell = ../scripts/bin/lint-shell/main.nix;
  root.local-ci = ../scripts/bin/local-ci/main.nix;
}
