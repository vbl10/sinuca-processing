import java.util.ArrayList;

class Aplicacao
{
  private GuiPagina pagina = new GuiPagina();
  private ArrayList<GuiComponente> ultimasPaginas = new ArrayList<>();
  
  private GuiComponente componenteFocoMouse = null;
  private GuiComponente componenteFocoTeclado = null;
  
  
  public Aplicacao(GuiPagina paginaInicial)
  {
    pagina.camadas.add(paginaInicial);
  }
  
  public void mudarPagina(GuiPagina novaPagina, boolean adicionarAoHistorico)
  {
    if (novaPagina != pagina.camadas.get(0))
    {
      if (adicionarAoHistorico)
        ultimasPaginas.add(pagina.camadas.get(0));
      pagina.camadas.clear();
      pagina.camadas.add(novaPagina);
    }
  }
  
  public void voltarPagina()
  {
    if (!ultimasPaginas.isEmpty())
    {
      pagina.camadas.clear();
      pagina.camadas.add(ultimasPaginas.get(ultimasPaginas.size() - 1));
      ultimasPaginas.remove(ultimasPaginas.size() - 1);
    }
  }
  
  public void abrirPopUp(GuiPagina popUp)
  {
    if (componenteFocoTeclado != null)
    {
      componenteFocoTeclado.aoMudarFocoTeclado(false);
      componenteFocoTeclado = null;  
    }
    pagina.camadas.add(popUp);
  }
  
  public void fecharPopUp()
  {
    if (pagina.camadas.size() > 1)
    {
      pagina.camadas.remove(pagina.camadas.size() - 1);
    }
  }
  
  public void aoMoverMouse()
  {
    if (componenteFocoMouse == null || !componenteFocoMouse.mouseCapturado())
    {  
      GuiComponente novoFoco = pagina.contemMouse(); 
      if (novoFoco != componenteFocoMouse)
      {
        if (novoFoco != null)
          novoFoco.aoMudarFocoMouse(true);
        if (componenteFocoMouse != null)
          componenteFocoMouse.aoMudarFocoMouse(false);
        componenteFocoMouse = novoFoco;
      }
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
    pagina.atualizar(dt);
  }
  
  public void desenhar()
  {
    background(0);
    pagina.desenhar();
  }
}
