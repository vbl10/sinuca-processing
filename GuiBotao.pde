interface GuiTratadorDeEventoBotao
{
  void aoAcionar(GuiBotao botao);
}

class GuiBotao extends GuiComponente
{
  Coord pos, tam;
  String texto;
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
  GuiBotao(String texto, GuiTratadorDeEventoBotao tratador)
  {
    this.pos = new Coord();
    this.tam = new Coord();
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
    fill(255);
    textAlign(CENTER, CENTER);
    text(texto, pos.x + tam.x / 2, pos.y + tam.y / 2);
  }
}
