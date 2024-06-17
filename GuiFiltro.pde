class GuiFiltro extends GuiComponente
{
  color cor;
  public GuiFiltro(color cor)
  {
    this.cor = cor;
  }
  @Override
  void desenhar()
  {
    noStroke();
    fill(cor);
    rect(0, 0, width, height);
  }
}
