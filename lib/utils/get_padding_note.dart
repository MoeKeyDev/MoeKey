double getPaddingForNote(constraints) {
  double padding = 0;
  if (constraints.maxWidth > 860) {
    padding = (constraints.maxWidth - 800) / 2;
  } else if (constraints.maxWidth > 500) {
    padding = 30;
  } else if (constraints.maxWidth > 400) {
    padding = 8;
  } else {
    padding = 0;
  }
  return padding;
}
