import java.util.ArrayList;

class Aplicacao
{
  private GuiPagina paginaAtual;
  private ArrayList<GuiPagina> ultimasPaginas = new ArrayList<>();
  
  private GuiComponente componenteFocoMouse = null;
  private GuiComponente componenteFocoTeclado = null;
  
  
  public Aplicacao(GuiPagina paginaInicial)
  {
    paginaAtual = paginaInicial;
  }
  
  public void mudarPagina(GuiPagina novaPagina, boolean adicionarAoHistorico, boolean limparPopups)
  {
    if (novaPagina != paginaAtual)
    {
      if (adicionarAoHistorico)
        ultimasPaginas.add(paginaAtual);
      if (limparPopups)
        paginaAtual.popups.clear();
      paginaAtual = novaPagina;
      novaPagina.aoMostrar();
      atualizarFocoMouse();
    }
  }
  
  public void voltarPagina(boolean limparPopups)
  {
    if (!ultimasPaginas.isEmpty())
    {
      if (limparPopups)
        paginaAtual.popups.clear();
      paginaAtual = ultimasPaginas.get(ultimasPaginas.size() - 1);
      ultimasPaginas.remove(ultimasPaginas.size() - 1);
      
      atualizarFocoMouse();
    }
  }
  
  public void abrirPopUp(GuiPagina popUp)
  {
    if (componenteFocoTeclado != null)
    {
      componenteFocoTeclado.aoMudarFocoTeclado(false);
      componenteFocoTeclado = null;  
    }
    paginaAtual.popups.add(popUp);
    
    atualizarFocoMouse();
  }
  
  public void fecharPopUp()
  {
    if (paginaAtual.popups.size() > 0)
    {
      if (componenteFocoTeclado != null)
      {
        componenteFocoTeclado.aoMudarFocoTeclado(false);
        componenteFocoTeclado = null;  
      }
      paginaAtual.popups.remove(paginaAtual.popups.size() - 1);
      
      atualizarFocoMouse();
    }
  }
  
  public void aoMoverMouse()
  {
    if (componenteFocoMouse == null || !componenteFocoMouse.mouseCapturado())
    {  
      atualizarFocoMouse();
    }
    if (componenteFocoMouse != null)
    {
      componenteFocoMouse.aoMoverMouse();
    }
  }
  public void aoClicarMouse()
  {
    if (componenteFocoMouse != null)
    {
      if (componenteFocoTeclado != componenteFocoMouse)
      {
        if (componenteFocoTeclado != null)
          componenteFocoTeclado.aoMudarFocoTeclado(false);
        componenteFocoTeclado = componenteFocoMouse;
        componenteFocoTeclado.aoMudarFocoTeclado(true);
      }
      componenteFocoMouse.aoClicarMouse();
    }
    else if (componenteFocoTeclado != null)
    {
      componenteFocoTeclado.aoMudarFocoTeclado(false);
      componenteFocoTeclado = null;
    }
  }
  public void aoRolarRodaMouse(MouseEvent evento)
  {
    if (componenteFocoMouse != null)
    {
      componenteFocoMouse.aoRolarRodaMouse(evento);
    }
  }
  public void aoPressionarTecla()
  {
    if (componenteFocoTeclado != null)
    {
      componenteFocoTeclado.aoPressionarTecla();
    }
  }
  
  public void atualizar(float dt)
  {  
    paginaAtual.atualizar(dt);
  }
  
  public void desenhar()
  {
    background(0);
    paginaAtual.desenhar();
  }
  
  public void atualizarFocoMouse()
  {
    GuiComponente novoFoco = paginaAtual.contemMouse(); 
    if (novoFoco != componenteFocoMouse)
    {
      if (novoFoco != null)
        novoFoco.aoMudarFocoMouse(true);
      if (componenteFocoMouse != null)
        componenteFocoMouse.aoMudarFocoMouse(false);
      componenteFocoMouse = novoFoco;
    }
  }
}
