class GuiTempo extends GuiComponente
{
  public Coord pos;
  GuiTempo(Coord pos)
  {
    this.pos = pos;
  }
  @Override
  void desenhar()
  {
    fill(255);
    textAlign(LEFT, TOP);
    text(
      "Tempo: " + formatarTempo((int)jogo.tempo),
      pos.x, pos.y
    ); 
  }
}
