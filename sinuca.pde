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
GuiPagina paginaFimDeJogo = new GuiPagina();

Aplicacao aplicacao = new Aplicacao(paginaInicial);

void mouseMoved()
{
  aplicacao.aoMoverMouse();
}
void mousePressed()
{
  aplicacao.aoClicarMouse();
}
void mouseWheel(MouseEvent evento)
{
  aplicacao.aoRolarRodaMouse(evento);
}

void keyPressed()
{
  aplicacao.aoPressionarTecla();
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
  paginaInicial.camadas.add(new GuiBotao("Corrida Contra o Tempo", loadImage("icone-jogar.png"), new Coord(20f, 300f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      jogo.modoDeJogo = jogo.MODO_CORRIDA_CONTRA_O_TEMPO;
      jogo.pausa = false;
      jogo.reiniciar();
      aplicacao.mudarPagina(paginaJogoCorridaContraTempo, false);
    }
  }));
  paginaInicial.camadas.add(new GuiBotao("Livre", loadImage("icone-jogar.png"), new Coord(20f, 335f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      jogo.modoDeJogo = jogo.MODO_LIVRE;
      jogo.pausa = false;
      jogo.reiniciar();
      aplicacao.mudarPagina(paginaJogoLivre, false);
    }
  }));
  //botao tutorial (redirecionar para pagina tutorial)
  //botao controles (redirecionar para pagina controles)
  paginaInicial.camadas.add(new GuiBotao("Dificuldade", new Coord(20f, 370f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      aplicacao.mudarPagina(paginaDificuldade, true);
    }
  }));
  //botao creditos (redirecionar para pagina creditos)
  
  //PAGINA CONTROLES ======================================
  paginaControles.camadas.add(new GuiRotulo("Controles", new Coord(20f, 200f)));
  //rotulo com todos os controles
  //botao voltar
  
  //PAGINA DIFICULDADE ====================================
  paginaDificuldade.camadas.add(new GuiRotulo("Dificuldade", new Coord(20f, 200f)));
  ArrayList<GuiBotao> grupoRadioDificuldade = new ArrayList<>();
  GuiTratadorDeEventoBotao tratadorRadioDificuldade = new GuiTratadorDeEventoBotao() {
    @Override
    void aoAtivar(GuiBotao botao, int id)
    {
      switch (id) //<>//
      {
        case 0:
          jogo.definirDificuldade(Jogo.DIFICULDADE_FACIL);
          break;
        case 1:
          jogo.definirDificuldade(Jogo.DIFICULDADE_MEDIO);
          break;
        case 2:
          jogo.definirDificuldade(Jogo.DIFICULDADE_DIFICIL);
          break;
      }
    }
  };
  paginaDificuldade.camadas.add(new GuiBotao("Facil", new Coord(20f, 300f), new Coord(200f, 30f), grupoRadioDificuldade, tratadorRadioDificuldade));
  grupoRadioDificuldade.get(0).alternarEstado(true);
  paginaDificuldade.camadas.add(new GuiBotao("Médio", new Coord(20f, 335f), new Coord(200f, 30f), grupoRadioDificuldade, tratadorRadioDificuldade));
  paginaDificuldade.camadas.add(new GuiBotao("Difícil", new Coord(20f, 370f), new Coord(200f, 30f), grupoRadioDificuldade, tratadorRadioDificuldade));
  paginaDificuldade.camadas.add(new GuiBotao("Voltar", new Coord(20f, 405f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      aplicacao.voltarPagina();
    }
  }));
  
  //PAGINA CREDITOS =======================================
  paginaCreditos.camadas.add(new GuiRotulo("Créditos", new Coord(20f, 200f)));
  //rotulo com integrantes do grupo
  //botao voltar
  
  GuiBotao botaoPausa = new GuiBotao(loadImage("icone-lista.png"), new Coord(10f, 10f), new Coord(30f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      jogo.pausa = true;
      aplicacao.abrirPopUp(paginaPausa);
    }
  });
  
  //PAGINA CORRIDA CONTRA O TEMPO =========================
  paginaJogoCorridaContraTempo.camadas.add(jogo);
  //botao pausa (modificar classe botao para suportar icones e usar icone de lista)
  paginaJogoCorridaContraTempo.camadas.add(botaoPausa);
  paginaJogoCorridaContraTempo.camadas.add(new GuiBolasForaDeJogo(new Coord(500f, 20f)));
  paginaJogoCorridaContraTempo.camadas.add(new GuiTempo(new Coord(200f, 20f)));
  paginaJogoCorridaContraTempo.camadas.add(new GuiPotenciaTacada(new Coord(15f, 100f), new Coord(20f, 400f)));
  /*
  paginaJogoCorridaContraTempo.camadas.add(new GuiInspetor(new Coord(20f, 100f), new GuiInspetorVarRef() {
    @Override
    String apurarValor()
    {
      float velMax = 0.0f;
      for (int i = 0; i < 16; i++)
      {
        velMax = max(velMax, jogo.bolas[i].vel.mag());
      }
      return "" + velMax;
    }
  }));
  */
  //PAGINA LIVRE ==========================================
  paginaJogoLivre.camadas.add(jogo);
  paginaJogoLivre.camadas.add(botaoPausa);
  paginaJogoLivre.camadas.add(new GuiBolasForaDeJogo(new Coord(500f, 20f)));
  paginaJogoLivre.camadas.add(new GuiPotenciaTacada(new Coord(15f, 100f), new Coord(20f, 400f)));
  
  //PAGINA TUTORIAL =======================================
  
  //PAGINA PAUSA ==========================================
  paginaPausa.camadas.add(new GuiRotulo("Pausa", new Coord(20f, 200f)));
  paginaPausa.camadas.add(new GuiBotao("Continuar", new Coord(20f, 230f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      aplicacao.fecharPopUp();
      jogo.pausa = false;
    }
  }));
  paginaPausa.camadas.add(new GuiBotao("Reiniciar", new Coord(20f, 260f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      aplicacao.fecharPopUp();
      jogo.pausa = false;
      jogo.reiniciar();
    }
  }));
  paginaPausa.camadas.add(new GuiBotao("Sair", new Coord(20f, 290f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      aplicacao.mudarPagina(paginaInicial, false);
    }
  }));
  
  //PAGINA FIM DE JOGO ====================================
  paginaFimDeJogo.camadas.add(new GuiRotulo("Fim de Jogo", new Coord(200f, 200f)));
  paginaFimDeJogo.camadas.add(new GuiInspetor(new Coord(200f, 230f), new GuiInspetorVarRef() {
    @Override
    String apurarValor()
    {
      if (jogo.corridaContraTempoFalhou)
      {
        return "Você perdeu!";
      }
      else
      {
        return 
          "Seu tempo:    " + formatarTempo((int)jogo.tempo) + (jogo.novoRecorde ? " - Novo recorde!" : "") + "\n" +
          "Melhor tempo: " + formatarTempo((int)jogo.melhorTempo);
      }
    }
  }));
  paginaFimDeJogo.camadas.add(new GuiBotao("Tentar novamente", new Coord(200f, 290f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      aplicacao.fecharPopUp();
      jogo.reiniciar();
      jogo.pausa = false;
    }
  }));
  paginaFimDeJogo.camadas.add(new GuiBotao("Sair", new Coord(200f, 330f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      aplicacao.mudarPagina(paginaInicial, false);
    }
  }));
  
}


int tp1 = 0, tp2 = 0; 
float dt = 0.0f;

void draw()
{
  aplicacao.atualizar(dt);
  aplicacao.desenhar();
  
  //medir tempo de geração desse quadro
  tp2 = millis();
  dt = (float)(tp2 - tp1) / 1000.0f;
  tp1 = millis();
}
