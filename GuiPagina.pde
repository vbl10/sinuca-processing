import java.util.ArrayList;

class GuiPagina extends GuiComponente
{
  ArrayList<GuiComponente> camadas = new ArrayList<GuiComponente>();
  
  GuiComponente contemMouse()
  {
    GuiComponente comp = null;
    
    for (int i = camadas.size() - 1; i >= 0 && (comp = camadas.get(i).contemMouse()) == null; i--);
    
    return comp != null ? comp : this;
  }
  
  void aoMostrar()
  {
    for (int i = 0; i < camadas.size(); i++) camadas.get(i).aoMostrar();
  }
  
  void atualizar(float dt)
  {
    for (int i = 0; i < camadas.size(); i++)
    {
      camadas.get(i).atualizar(dt);
    }
  }
  
  void desenhar()
  {
    for (int i = 0; i < camadas.size(); i++)
    {
      camadas.get(i).desenhar();
    }
  }
}
