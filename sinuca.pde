import java.util.ArrayList;

//unidade de distância:  cm
//unidade de tempo:      s

Jogo jogo = new Jogo();

GuiPagina paginaInicial = new GuiPagina();
GuiPagina paginaControles = new GuiPagina();
GuiPagina paginaDificuldade = new GuiPagina();
GuiPagina paginaCreditos = new GuiPagina();

GuiPagina paginaJogoCorridaContraTempo = new GuiPagina();
GuiPagina paginaJogoLivre = new GuiPagina();
GuiPagina paginaJogoTutorial = new GuiPagina();

GuiPagina paginaPausa = new GuiPagina();


GuiPagina paginaAtual = paginaInicial;
GuiComponente componenteFocoMouse = null;
GuiComponente componenteFocoTeclado = null;

int tpCronometro = 0;

void mouseMoved()
{
  if (componenteFocoMouse == null || !componenteFocoMouse.mouseCapturado())
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
  if (componenteFocoMouse != null)
  {
    componenteFocoMouse.aoMoverMouse();
  }
}
void mousePressed()
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
void mouseWheel(MouseEvent evento)
{
  if (componenteFocoMouse != null)
  {
    componenteFocoMouse.aoRolarRodaMouse(evento);
  }
}

void keyPressed()
{
  if (componenteFocoTeclado != null)
  {
    componenteFocoTeclado.aoPressionarTecla();
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
  
  textSize(16);
  
  //PAGINA INICIAL ========================================
  paginaInicial.camadas.add(new GuiRotulo("Sinucão do Kleyson", new Coord(20f, 270f)));
  paginaInicial.camadas.add(new GuiBotao("Corrida Contra o Tempo", new Coord(20f, 300f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      paginaAtual = paginaJogoCorridaContraTempo;
      jogo.pausa = false;
      jogo.reiniciar();
    }
  }));
  //botao jogo livre (redirecionar para pagina jogo livre)
  //botao tutorial (redirecionar para pagina tutorial)
  //botao controles (redirecionar para pagina controles)
  //botao dificuldade (redirecionar para pagina dificuldade)
  //botao creditos (redirecionar para pagina creditos)

  //PAGINA CONTROLES ======================================
  paginaControles.camadas.add(new GuiRotulo("Controles", new Coord(20f, 200f)));
  //rotulo com todos os controles
  //botao voltar
  
  //PAGINA DIFICULDADE ====================================
  paginaDificuldade.camadas.add(new GuiRotulo("Dificuldade", new Coord(20f, 200f)));
  //botao facil (jogo.tacadaTrajetoria = true; jogo.tacadaTrajetoriaColisaoBola = true)
  //botao medio (jogo.tacadaTrajetoria = true; jogo.tacadaTrajetoriaColisaoBola = false)
  //botao dificil (jogo.tacadaTrajetoria = false; jogo.tacadaTrajetoriaColisaoBola = false)
  //botao voltar
  
  //PAGINA CREDITOS =======================================
  paginaCreditos.camadas.add(new GuiRotulo("Créditos", new Coord(20f, 200f)));
  //rotulo com integrantes do grupo
  //botao voltar
  
  GuiBotao botaoPausa = new GuiBotao("P", new Coord(10f, 10f), new Coord(30f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      jogo.pausa = true;
      botao.aoMudarFocoTeclado(false);
      componenteFocoTeclado = null;
      paginaAtual.camadas.add(paginaPausa);
    }
  });
  
  //PAGINA CORRIDA CONTRA O TEMPO =========================
  paginaJogoCorridaContraTempo.camadas.add(jogo);
  //botao pausa (modificar classe botao para suportar icones e usar icone de lista)
  paginaJogoCorridaContraTempo.camadas.add(botaoPausa);
  paginaJogoCorridaContraTempo.camadas.add(new GuiTempo(new Coord(100f, 10f)));
  
  //PAGINA LIVRE ==========================================
  
  //PAGINA TUTORIAL =======================================
  
  //PAGINA PAUSA ==========================================
  paginaPausa.camadas.add(new GuiRotulo("Pausa", new Coord(20f, 200f)));
  paginaPausa.camadas.add(new GuiBotao("Continuar", new Coord(20f, 230f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      paginaAtual.camadas.remove(paginaAtual.camadas.size() - 1);
      jogo.pausa = false;
    }
  }));
  paginaPausa.camadas.add(new GuiBotao("Reiniciar", new Coord(20f, 260f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      paginaAtual.camadas.remove(paginaAtual.camadas.size() - 1);
      jogo.pausa = false;
      jogo.reiniciar();
    }
  }));
  paginaPausa.camadas.add(new GuiBotao("Sair", new Coord(20f, 290f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      paginaAtual.camadas.remove(paginaAtual.camadas.size() - 1);
      paginaAtual = paginaInicial;
    }
  }));
  
}


int tp1 = 0, tp2 = 0; 
float dt = 0.0f;

void draw()
{
  paginaAtual.atualizar(dt);
  
  background(0);
  paginaAtual.desenhar();
   
  
  //medir tempo de geração desse quadro
  tp2 = millis();
  dt = (float)(tp2 - tp1) / 1000.0f;
  tp1 = millis();
}
