import java.util.ArrayList;

//unidade de distância:  cm
//unidade de tempo:      s

Jogo jogo = new Jogo();

final int FERRAMENTA_JOGAR = 0;
final int FERRAMENTA_MOVER = 1;
int ferramenta = FERRAMENTA_JOGAR;
boolean ferramentaMoverMovendo = false;
Coord ferramentaMoverClique = new Coord();
Coord ferramentaMoverTransAntiga = new Coord();

Coord mouse()
{
  return new Coord(mouseX, mouseY);
}
void mousePressed()
{
  if (ferramenta == FERRAMENTA_JOGAR && mouseButton == LEFT)
  {
    jogo.aoClicarMouse();
  }
  else if ((ferramenta == FERRAMENTA_MOVER && mouseButton == LEFT) || mouseButton == RIGHT)
  {
    ferramentaMoverMovendo = !ferramentaMoverMovendo;
    if (ferramentaMoverMovendo)
    {
      ferramenta = FERRAMENTA_MOVER;
      ferramentaMoverClique.def(mouseX, mouseY);
      ferramentaMoverTransAntiga.def(jogo.translacao);
    }
    else
    {
      ferramenta = FERRAMENTA_JOGAR;
    }
  }
}
void mouseMoved()
{
  if (ferramenta == FERRAMENTA_JOGAR)
  {
    jogo.aoMoverMouse();
  }
  else if (ferramenta == FERRAMENTA_MOVER)
  {
    if (ferramentaMoverMovendo)
    {
      jogo.translacao.def(
        ferramentaMoverTransAntiga
        .soma(mouse())
        .sub(ferramentaMoverClique)
      );
    }
  }
}

void mouseWheel(MouseEvent evento)
{
  Coord mouseTela = new Coord(mouseX, mouseY);
  Coord mouseMundoAntigo = jogo.telaParaMundo(mouseTela);
  
  if (evento.getCount() > 0)
      jogo.escala *= 1.2f;
  else
      jogo.escala /= 1.2f;

  Coord mouseMundoNovo = jogo.telaParaMundo(mouseTela);
  
  Coord translacao = jogo.mundoParaTela(mouseMundoNovo.sub(mouseMundoAntigo));
  
  jogo.translacao.def(translacao);
}

void keyPressed()
{
  if (key == 'r')
  {
    jogo.reiniciar();
  }
  else if (key == 'j')
  {
    ferramenta = FERRAMENTA_JOGAR;
  }
  else if (key == 'm')
  {
    ferramenta = FERRAMENTA_MOVER;
  }
  else if (key == 'x' || key == 'z')
  {
    Coord mouseTela = new Coord(mouseX, mouseY);
    Coord mouseMundoAntigo = jogo.telaParaMundo(mouseTela);
    
    jogo.rotacao += (key == 'x' ? 1f : -1f) * PI / 180f;
  
    Coord mouseMundoNovo = jogo.telaParaMundo(mouseTela);
    
    Coord translacao = jogo.mundoParaTela(mouseMundoNovo.sub(mouseMundoAntigo));
    
    jogo.translacao.def(translacao);
  }
  else if (key == 'p')
  {
    print("mouseTela:        "); print(mouseX); print(' '); println(mouseY);
  }
}

void setup()
{
  size(1200, 800);
  
  jogo.escala = width * 0.7f / jogo.mesa.tamanho.x;
  if (jogo.escala * jogo.mesa.tamanho.y > height * 0.7f)
  {
    jogo.escala = height * 0.7f / jogo.mesa.tamanho.y;
  }
  jogo.translacao.def(width / 2, height / 2);
    
  cores.inicializar();
}


int tp1 = 0, tp2 = 0; 
float dt = 0.0f;

void draw()
{
  jogo.atualizar(dt);
  
  //desenhar
  background(40,40,40);
  
  jogo.desenhar();
  
  textAlign(LEFT, TOP);
  fill(255);
  text(
    "Ferramenta: " + (
      ferramenta == FERRAMENTA_JOGAR ? "jogar" :
      ferramenta == FERRAMENTA_MOVER ? "mover" : ""
    ),
    10, 10
  );
  
  //medir tempo de geração desse quadro
  tp2 = millis();
  dt = (float)(tp2 - tp1) / 1000.0f;
  tp1 = millis();
}
