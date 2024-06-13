import java.util.ArrayList;

class GuiColecao extends GuiComponente
{
  ArrayList<GuiComponente> componentes;
  
  void desenhar()
  {
    for (int i = 0; i < componentes.size(); i++)
    {
      componentes.get(i).desenhar();
    }
  }
}
