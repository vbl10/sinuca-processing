import java.util.ArrayList;
class GuiTratadorDeEventoBotao
{
  //botoes normais
  void aoAcionar(GuiBotao botao) {}
  //botoes do tipo radio
  void aoAtivar(GuiBotao botao, int id) {}
}

class GuiBotao extends GuiComponente
{
  public Coord pos, tam;
  public String texto = null;
  public GuiImagem icone = null;
  GuiTratadorDeEventoBotao tratador;
  
  boolean focoMouse = false;
  boolean focoTeclado = false;
  
  boolean alternar = false;
  boolean estado = false;
  ArrayList<GuiBotao> grupoRadio = null;
  int grupoRadioId = 0;
  
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
  GuiBotao(String texto, Coord pos, Coord tam, boolean alternar, GuiTratadorDeEventoBotao tratador)
  {
    this.alternar = alternar;
    this.pos = pos;
    this.tam = tam;
    this.texto = texto;
    this.tratador = tratador;
  }
  GuiBotao(PImage icone, Coord pos, Coord tam, boolean alternar, GuiTratadorDeEventoBotao tratador)
  {
    this.alternar = alternar;
    this.pos = pos;
    this.tam = tam;
    this.icone = new GuiImagem(icone, pos, new Coord(tam.y, tam.y), GuiImagem.MODO_CABER, new Coord(0.5f, 0.5f));
    this.tratador = tratador;
  }
  GuiBotao(String texto, PImage icone, Coord pos, Coord tam, boolean alternar, GuiTratadorDeEventoBotao tratador)
  {
    this.alternar = alternar;
    this.pos = pos;
    this.tam = tam;
    this.icone = new GuiImagem(icone, pos, new Coord(tam.y, tam.y), GuiImagem.MODO_CABER, new Coord(0.5f, 0.5f));
    this.texto = texto;
    this.tratador = tratador;
  }
  GuiBotao(String texto, Coord pos, Coord tam, ArrayList<GuiBotao> grupoRadio, GuiTratadorDeEventoBotao tratador)
  {
    this.grupoRadioId = grupoRadio.size();
    grupoRadio.add(this);
    this.grupoRadio = grupoRadio;
    this.alternar = true;
    this.pos = pos;
    this.tam = tam;
    this.texto = texto;
    this.tratador = tratador;
  }
  GuiBotao(PImage icone, Coord pos, Coord tam, ArrayList<GuiBotao> grupoRadio, GuiTratadorDeEventoBotao tratador)
  {
    this.grupoRadioId = grupoRadio.size();
    grupoRadio.add(this);
    this.grupoRadio = grupoRadio;
    this.alternar = true;
    this.pos = pos;
    this.tam = tam;
    this.icone = new GuiImagem(icone, pos, new Coord(tam.y, tam.y), GuiImagem.MODO_CABER, new Coord(0.5f, 0.5f));
    this.tratador = tratador;
  }
  GuiBotao(String texto, PImage icone, Coord pos, Coord tam, ArrayList<GuiBotao> grupoRadio, GuiTratadorDeEventoBotao tratador)
  {
    this.grupoRadioId = grupoRadio.size();
    grupoRadio.add(this);
    this.grupoRadio = grupoRadio;
    this.alternar = true;
    this.pos = pos;
    this.tam = tam;
    this.icone = new GuiImagem(icone, pos, new Coord(tam.y, tam.y), GuiImagem.MODO_CABER, new Coord(0.5f, 0.5f));
    this.texto = texto;
    this.tratador = tratador;
  }
  
  void alternarEstado(boolean novoEstado)
  {
    if (grupoRadio != null && novoEstado == true && estado == false)
    {
      for (int i = 0; i < grupoRadio.size(); i++)
      {
        if (grupoRadio.get(i).estado)
        {
          grupoRadio.get(i).estado = false;
          break;
        }        
      }
      estado = true;
      tratador.aoAtivar(this, grupoRadioId);
    }
    else estado = novoEstado;
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
    if (alternar)
    {
      alternarEstado(!estado);
    }
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
    stroke(128 + (focoMouse || focoTeclado ? 20 : 0));
    strokeWeight(3);
    fill(167 + (focoMouse ? 20 : 0) - (alternar && estado ? 60 : 0));
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
