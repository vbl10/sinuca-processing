import java.util.ArrayList;
class GuiBotaoTratadorDeEvento
{
  //botoes normais
  void aoAcionar(GuiBotao botao) {}
  //botoes do tipo radio
  void aoEscolher(GuiBotao botao, int escolha) {}
}

class GuiBotaoGrupoRadio
{
  ArrayList<GuiBotao> grupo = new ArrayList<>();
  final int adicionar(GuiBotao botao)
  {
    int novoId = grupo.size();
    grupo.add(botao);
    return novoId;
  }
  final void atualizar(int escolha)
  {
    for (int i = 0; i < grupo.size(); i++)
      grupo.get(i).estado = false;
    grupo.get(escolha).estado = true;
  }
}

class GuiBotao extends GuiComponente
{
  public Coord pos, tam;
  public String texto = null;
  public GuiImagem icone = null;
  GuiBotaoTratadorDeEvento tratador;
  
  boolean focoMouse = false;
  boolean focoTeclado = false;
  
  boolean alternar = false;
  boolean estado = false;
  GuiBotaoGrupoRadio grupoRadio = null;
  int grupoRadioId = 0;
  
  GuiBotao(String texto, Coord pos, Coord tam, GuiBotaoTratadorDeEvento tratador)
  {
    this.pos = pos;
    this.tam = tam;
    this.texto = texto;
    this.tratador = tratador;
  }
  GuiBotao(PImage icone, Coord pos, Coord tam, GuiBotaoTratadorDeEvento tratador)
  {
    this.pos = pos;
    this.tam = tam;
    this.icone = new GuiImagem(icone, pos, new Coord(tam.y, tam.y), GuiImagem.MODO_CABER, new Coord(0.5f, 0.5f));
    this.tratador = tratador;
  }
  GuiBotao(String texto, PImage icone, Coord pos, Coord tam, GuiBotaoTratadorDeEvento tratador)
  {
    this.pos = pos;
    this.tam = tam;
    this.icone = new GuiImagem(icone, pos, new Coord(tam.y, tam.y), GuiImagem.MODO_CABER, new Coord(0.5f, 0.5f));
    this.texto = texto;
    this.tratador = tratador;
  }
  GuiBotao(String texto, Coord pos, Coord tam, boolean alternar, GuiBotaoTratadorDeEvento tratador)
  {
    this.alternar = alternar;
    this.pos = pos;
    this.tam = tam;
    this.texto = texto;
    this.tratador = tratador;
  }
  GuiBotao(PImage icone, Coord pos, Coord tam, boolean alternar, GuiBotaoTratadorDeEvento tratador)
  {
    this.alternar = alternar;
    this.pos = pos;
    this.tam = tam;
    this.icone = new GuiImagem(icone, pos, new Coord(tam.y, tam.y), GuiImagem.MODO_CABER, new Coord(0.5f, 0.5f));
    this.tratador = tratador;
  }
  GuiBotao(String texto, PImage icone, Coord pos, Coord tam, boolean alternar, GuiBotaoTratadorDeEvento tratador)
  {
    this.alternar = alternar;
    this.pos = pos;
    this.tam = tam;
    this.icone = new GuiImagem(icone, pos, new Coord(tam.y, tam.y), GuiImagem.MODO_CABER, new Coord(0.5f, 0.5f));
    this.texto = texto;
    this.tratador = tratador;
  }
  GuiBotao(String texto, Coord pos, Coord tam, GuiBotaoGrupoRadio grupoRadio, GuiBotaoTratadorDeEvento tratador)
  {
    this.grupoRadioId = grupoRadio.adicionar(this);
    this.grupoRadio = grupoRadio;
    this.alternar = true;
    this.pos = pos;
    this.tam = tam;
    this.texto = texto;
    this.tratador = tratador;
  }
  GuiBotao(PImage icone, Coord pos, Coord tam, GuiBotaoGrupoRadio grupoRadio, GuiBotaoTratadorDeEvento tratador)
  {
    this.grupoRadioId = grupoRadio.adicionar(this);
    this.grupoRadio = grupoRadio;
    this.alternar = true;
    this.pos = pos;
    this.tam = tam;
    this.icone = new GuiImagem(icone, pos, new Coord(tam.y, tam.y), GuiImagem.MODO_CABER, new Coord(0.5f, 0.5f));
    this.tratador = tratador;
  }
  GuiBotao(String texto, PImage icone, Coord pos, Coord tam, GuiBotaoGrupoRadio grupoRadio, GuiBotaoTratadorDeEvento tratador)
  {
    this.grupoRadioId = grupoRadio.adicionar(this);
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
    if (grupoRadio != null) //<>//
    {
      if (novoEstado == true && estado == false)
      {
        grupoRadio.atualizar(grupoRadioId);
        tratador.aoEscolher(this, grupoRadioId);
      }
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

class GuiBotaoRedirecionar extends GuiBotao
{
  public GuiPagina ref;
  boolean adicionarAoHistorico;
  boolean limparPopups;
  public GuiBotaoRedirecionar(String texto, Coord pos, Coord tam, GuiPagina ref, boolean adicionarAoHistorico, boolean limparPopups)
  {
    super(texto, pos, tam, new GuiBotaoTratadorDeEvento() { @Override void aoAcionar(GuiBotao botao) { aplicacao.mudarPagina(ref, adicionarAoHistorico, limparPopups); }});
    this.ref = ref;
    this.adicionarAoHistorico = adicionarAoHistorico;
    this.limparPopups = limparPopups;
  }
  public GuiBotaoRedirecionar(PImage icone, Coord pos, Coord tam, GuiPagina ref, boolean adicionarAoHistorico, boolean limparPopups)
  {
    super(icone, pos, tam, new GuiBotaoTratadorDeEvento() { @Override void aoAcionar(GuiBotao botao) { aplicacao.mudarPagina(ref, adicionarAoHistorico, limparPopups); }});
    this.ref = ref;
    this.adicionarAoHistorico = adicionarAoHistorico;
    this.limparPopups = limparPopups;
  }
  public GuiBotaoRedirecionar(String texto, PImage icone, Coord pos, Coord tam, GuiPagina ref, boolean adicionarAoHistorico, boolean limparPopups)
  {
    super(texto, icone, pos, tam, new GuiBotaoTratadorDeEvento() { @Override void aoAcionar(GuiBotao botao) { aplicacao.mudarPagina(ref, adicionarAoHistorico, limparPopups); }});
    this.ref = ref;
    this.adicionarAoHistorico = adicionarAoHistorico;
    this.limparPopups = limparPopups;
  }
}

class GuiBotaoPopUp extends GuiBotao
{
  public GuiPagina popup;
  public GuiBotaoPopUp(String texto, Coord pos, Coord tam, GuiPagina popup)
  {
    super(texto, pos, tam, new GuiBotaoTratadorDeEvento() { @Override void aoAcionar(GuiBotao botao) { aplicacao.abrirPopUp(popup); }});
    this.popup = popup;
  }
  public GuiBotaoPopUp(PImage icone, Coord pos, Coord tam, GuiPagina popup)
  {
    super(icone, pos, tam, new GuiBotaoTratadorDeEvento() { @Override void aoAcionar(GuiBotao botao) { aplicacao.abrirPopUp(popup); }});
    this.popup = popup;
  }
  public GuiBotaoPopUp(String texto, PImage icone, Coord pos, Coord tam, GuiPagina popup)
  {
    super(texto, icone, pos, tam, new GuiBotaoTratadorDeEvento() { @Override void aoAcionar(GuiBotao botao) { aplicacao.abrirPopUp(popup); }});
    this.popup = popup;
  }
}


class GuiBotaoVoltar extends GuiBotao
{
  public GuiBotaoVoltar(String texto, Coord pos, Coord tam, boolean limparPopups)
  {
    super(texto, pos, tam, new GuiBotaoTratadorDeEvento() { @Override void aoAcionar(GuiBotao botao) { aplicacao.voltarPagina(limparPopups); }});
  }
  public GuiBotaoVoltar(PImage icone, Coord pos, Coord tam, boolean limparPopups)
  {
    super(icone, pos, tam, new GuiBotaoTratadorDeEvento() { @Override void aoAcionar(GuiBotao botao) { aplicacao.voltarPagina(limparPopups); }});
  }
  public GuiBotaoVoltar(String texto, PImage icone, Coord pos, Coord tam, boolean limparPopups)
  {
    super(texto, icone, pos, tam, new GuiBotaoTratadorDeEvento() { @Override void aoAcionar(GuiBotao botao) { aplicacao.voltarPagina(limparPopups); }});
  }
}
