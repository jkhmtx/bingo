export class Downloadable {
  private blob: Blob;
  private link: HTMLAnchorElement;
  private url?: string;
  constructor(blob: Blob, name: string) {
    this.blob = blob;
    this.link = document.createElement("a");
    this.link.download = name;
  }

  private get dataUrl(): string {
    if (this.url) {
      return this.url;
    }

    this.url = URL.createObjectURL(this.blob);

    return this.url;
  }

  start(): void {
    this.link.href = this.dataUrl;

    document.body.appendChild(this.link);
    this.link.click();
  }

  [Symbol.dispose]() {
    document.body.removeChild(this.link);

    setTimeout(() => {
      if (this.url) {
        URL.revokeObjectURL(this.url);
      }
    }, 100);
  }
}
