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
    int cronometro = (int)jogo.tempo;
    text(
      "Tempo: " + cronometro / 600 + "" + cronometro / 60 % 10 + ":" + cronometro % 60 / 10 + "" + cronometro % 60 % 10,
      pos.x, pos.y
    ); 
  }
}
