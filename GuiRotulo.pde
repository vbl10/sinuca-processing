class GuiRotulo extends GuiComponente
{
  public Coord pos;
  public String texto;
  
  public GuiRotulo(String texto, Coord pos)
  {
    this.texto = texto;
    this.pos = pos;
  }
  
  @Override
  void desenhar()
  {
    fill(255);
    textAlign(LEFT, TOP);
    text(texto, pos.x, pos.y);
  }
}
