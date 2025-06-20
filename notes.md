- <https://superuser.com/questions/1581256/how-to-overlay-two-images-with-position-and-scale-in-imagemagick>
- <https://letsplaybingo.io/generator>

## Downloads

1. Get the bingo cards in a big PDF using [this generator](https://letsplaybingo.io/generator). Save it to `pdfs/${batch}.pdf`
2. Get the background images from [google drive](https://drive.google.com/drive/folders/1k6Iy-zuTeke4_UnWv8_GhcQ6Xd27NF73?dmr=1&ec=wgc-drive-globalnav-goto), save it to `templates/${batch}.[png|jpg]` and `template/test.[png|jpg]`

## Vars

1. Check the `test.env` file to make sure its set with all options set to 1
2. Set the env vars in `batches/test/[crop|extract|single|double].env`
3. Use `./run.sh test` to run a test batch
4. When the vars are right, copy `batches/test/[crop|extract|single|double].env` to the batch dir
5. Use `./run.sh ${batch} all` to run the batch
