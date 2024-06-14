class GuiBolasForaDeJogo extends GuiComponente
{
  private final float espacamento = 8f;
  private final float tamCelula = 40f;
  private final float raioBola = 10f;
  private final int tamTexto = 16;
  private final float largura = tamCelula * 16f + 2f * espacamento;
  private final float altura = tamCelula + 2f * espacamento;
  
  private int bolaSelecionada = -1;
  
  public Coord pos;
  
  public GuiBolasForaDeJogo(Coord pos)
  {
    this.pos = pos;
  }
  
  @Override
  public GuiComponente contemMouse()
  {
    if (mouseX > pos.x && mouseX < pos.x + largura && mouseY > pos.y && mouseY < pos.y + altura)
      return this;
    return null;
  }
  
  @Override
  public void aoMoverMouse()
  {
    if (jogo.modoDeJogo == jogo.MODO_LIVRE && mouseY > pos.y + espacamento + tamTexto && mouseY < pos.y + altura - espacamento)
    {
      bolaSelecionada = (int)map(mouseX - pos.x - espacamento, 0, largura - 2f * espacamento, 0, 16);
      if (bolaSelecionada < 0 || bolaSelecionada > 15 || jogo.bolas[bolaSelecionada].estaEmJogo)
        bolaSelecionada = -1;
    }
  }
  
  @Override
  public void aoClicarMouse()
  {
    if (bolaSelecionada != -1)
    {
      jogo.posicionandoBola = bolaSelecionada;
    }
  }
  
  @Override
  public void aoMudarFocoMouse(boolean focado)
  {
    if (focado == false)
      bolaSelecionada = -1;
  }
  
  @Override
  public void desenhar()
  {
    fill(70);
    strokeWeight(3);
    stroke(100);
    rect(pos.x, pos.y, largura, altura);
    
    if (bolaSelecionada != -1 || jogo.posicionandoBola != -1)
    {
      fill(130);
      if (jogo.posicionandoBola != -1)
      {
        stroke(200, 200, 0);
        strokeWeight(3);
        rect(pos.x + jogo.posicionandoBola * tamCelula + espacamento, pos.y + espacamento, tamCelula, tamCelula);
      }
      else
      {
        noStroke();
        rect(pos.x + bolaSelecionada * tamCelula + espacamento, pos.y + espacamento, tamCelula, tamCelula);
      }
    }
    
    textSize(tamTexto);
    textAlign(CENTER, TOP);
    fill(255);
    for (int i = 0; i < 16; i++)
      text((i < 10 ? " " : "") + i, pos.x + i * tamCelula + 20 + espacamento, pos.y + espacamento);
      
    strokeWeight(3);
    stroke(100);
    for (int i = 0; i < 17; i++)
      line(pos.x + espacamento + i * tamCelula, pos.y + espacamento, pos.x + espacamento + i * tamCelula, pos.y + tamCelula + espacamento);
      
    for (int i = 0; i < 16; i++)
    {
      if (!jogo.bolas[i].estaEmJogo)
      {
        desenharBola(i, new Coord(pos.x + i * tamCelula + tamCelula / 2f + espacamento, pos.y + tamCelula - raioBola + espacamento), raioBola);
      }
    }
  }
}
