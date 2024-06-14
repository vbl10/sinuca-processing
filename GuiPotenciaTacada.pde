class GuiPotenciaTacada extends GuiComponente
{
  Coord pos, tam;
  
  public GuiPotenciaTacada(Coord pos, Coord tam)
  {
    this.pos = pos;
    this.tam = tam;
  }
  
  @Override
  void desenhar()
  {
    stroke(150);
    strokeWeight(tam.x);
    line(pos.x + tam.x/2, pos.y, pos.x + tam.x/2, pos.y + tam.y);
    
    colorMode(HSB, 360, 100, 100);
    stroke(map(jogo.tacadaPotencia, 0f, 1f, 120, 0), 100, 100);
    strokeWeight(tam.x * 0.5f);
    line(pos.x + tam.x/2, pos.y + tam.y, pos.x + tam.x/2, pos.y + tam.y * (1f - jogo.tacadaPotencia));
    colorMode(RGB, 255, 255, 255);
  }
}
