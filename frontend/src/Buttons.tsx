type ButtonsProps = {
  onDownloadClick: () => void;
  onViewButtonClick: (view: 1 | 2 | 3 | 4) => void;
  quantity: number;
  setQuantity: (quantity: number) => void;
};

export function Buttons({
  onDownloadClick,
  onViewButtonClick,
  quantity,
  setQuantity,
}: ButtonsProps) {
  return (
    <div className="button-bar">
      {([1, 2, 3, 4] as const).map((view) => (
        <button
          key={view}
          type="button"
          onClick={() => onViewButtonClick(view)}
        >
          {view}
        </button>
      ))}
      <label htmlFor="quantity">
        How many?
        <input
          type="number"
          min={1}
          max={5}
          value={quantity}
          onChange={(e) => setQuantity(e.target.valueAsNumber)}
        ></input>
      </label>
      <button className="download" type="button" onClick={onDownloadClick}>
        Download
      </button>
    </div>
  );
}
