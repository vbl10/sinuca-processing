interface GuiTratadorDeEventoBotao
{
  void aoAcionar(GuiBotao botao);
}

class GuiBotao extends GuiComponente
{
  public Coord pos, tam;
  public String texto = null;
  public GuiImagem icone = null;
  GuiTratadorDeEventoBotao tratador;
  
  boolean focoMouse = false;
  boolean focoTeclado = false;
  
  GuiBotao(String texto, Coord pos, Coord tam, GuiTratadorDeEventoBotao tratador)
  {
    this.pos = pos;
    this.tam = tam;
    this.texto = texto;
    this.tratador = tratador;
  }
  GuiBotao(PImage icone, Coord pos, Coord tam, GuiTratadorDeEventoBotao tratador)
  {
    this.pos = pos;
    this.tam = tam;
    this.icone = new GuiImagem(icone, pos, new Coord(tam.y, tam.y), GuiImagem.MODO_CABER, new Coord(0.5f, 0.5f));
    this.tratador = tratador;
  }
  GuiBotao(String texto, PImage icone, Coord pos, Coord tam, GuiTratadorDeEventoBotao tratador)
  {
    this.pos = pos;
    this.tam = tam;
    this.icone = new GuiImagem(icone, pos, new Coord(tam.y, tam.y), GuiImagem.MODO_CABER, new Coord(0.5f, 0.5f));
    this.texto = texto;
    this.tratador = tratador;
  }
  
  GuiComponente contemMouse()
  {
    if (mouseX > pos.x && mouseX < pos.x + tam.x && 
        mouseY > pos.y && mouseY < pos.y + tam.y)
      return this;
    return null;    
  }
  void aoMudarFocoMouse(boolean focado)
  {
    focoMouse = focado;
  }
  void aoClicarMouse()
  {
    tratador.aoAcionar(this);
  }
  void aoPressionarTecla()
  {
    if (key == ' ')
    {
      tratador.aoAcionar(this);
    }
  }
  void aoMudarFocoTeclado(boolean focado)
  {
    focoTeclado = focado;
  }
  
  void desenhar()
  {
    if (!focoTeclado)
      stroke(128 + (focoMouse ? 20 : 0));
    else
      stroke(200 + (focoMouse ? 20 : 0), 200 + (focoMouse ? 20 : 0), 0);
      
    strokeWeight(3);
    fill(167 + (focoMouse ? 20 : 0));
    rect(pos.x, pos.y, tam.x, tam.y);
    
    if (icone != null)
    {
      icone.desenhar();
    }
    if (texto != null)
    {
      fill(255);
      if (icone == null)
      {
        textAlign(CENTER, CENTER);
        text(texto, pos.x + tam.x / 2, pos.y + tam.y / 2);
      }
      else
      {
        textAlign(LEFT, CENTER);
        text(texto, pos.x + icone.tam.x, pos.y + tam.y / 2);
      }
    }
  }
}
