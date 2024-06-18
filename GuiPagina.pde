import java.util.ArrayList;

class GuiPagina extends GuiComponente
{
  ArrayList<GuiComponente> camadas = new ArrayList<>();
  ArrayList<GuiComponente> popups = new ArrayList<>();
  
  GuiComponente contemMouse()
  {
    GuiComponente comp = null;

    for (int i = popups.size() - 1; i >= 0 && comp == null; i--) comp = popups.get(i).contemMouse();
    for (int i = camadas.size() - 1; i >= 0 && comp == null; i--) comp = camadas.get(i).contemMouse();
    
    return comp != null ? comp : this;
  }
  
  void aoMostrar()
  {
    for (int i = 0; i < popups.size(); i++) popups.get(i).aoMostrar();
    for (int i = 0; i < camadas.size(); i++) camadas.get(i).aoMostrar();
  }
  
  void atualizar(float dt)
  {
    for (int i = 0; i < popups.size(); i++) popups.get(i).atualizar(dt);
    for (int i = 0; i < camadas.size(); i++) camadas.get(i).atualizar(dt);
  }
  
  void desenhar()
  {
    for (int i = 0; i < camadas.size(); i++) camadas.get(i).desenhar();
    for (int i = 0; i < popups.size(); i++) popups.get(i).desenhar();
  }
}
