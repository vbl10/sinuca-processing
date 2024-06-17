import java.util.ArrayList;
import ddf.minim.*; // Importa a biblioteca Minim para manipulação de áudio

Minim minim;
AudioSample somColisao;
AudioSample somColisaoMesa;
AudioSample somColisaoCacapa;
AudioPlayer somImpacto; // Declara um objeto AudioPlayer para reproduzir o som de impacto
AudioPlayer musicaFundo;

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

PImage img;            
GuiImagem guiImagem;
GuiCaixaDeTexto caixaDeTexto;
ArrayList<String> textos;
int textoAtualIndex = 0;

GuiBotaoGrupoRadio grupoRadioFerramentas = new GuiBotaoGrupoRadio();
GuiTratadorDeEventoBotao tratadorRadioFerramentas = new GuiTratadorDeEventoBotao() {
  @Override
  void aoEscolher(GuiBotao botao, int escolha)
  {
    jogo.definirFerramenta(escolha);
  }
};


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
  
  //SOM ==================================================
  minim = new Minim(this);
  somColisao = minim.loadSample("Colisao.mpga", 1024);
  somColisaoMesa = minim.loadSample("ColisaoMesa.mp3", 1024);
  somColisaoCacapa = minim.loadSample("ColisaoCacapa.mp3", 1024);
  somImpacto = minim.loadFile("Tacada.mp3");
  musicaFundo = minim.loadFile("MusicaFundo.mp3"); // Carrega a música de fundo

  if (somColisaoMesa == null) {
    println("Erro ao carregar o som de colisão.");
  } else {
    println("Som de colisão carregado com sucesso.");
    somColisaoMesa.setGain(0); // Aumenta o volume do som de colisão em 10 dB
 
 }
   if (somColisaoCacapa == null) {
    println("Erro ao carregar o som de colisão.");
  } else {
    println("Som de colisão carregado com sucesso.");
    somColisaoCacapa.setGain(-10); // Aumenta o volume do som de colisão em 10 dB
 
 }

    if (somColisao == null) {
    println("Erro ao carregar o som de colisão.");
  } else {
    println("Som de colisão carregado com sucesso.");
    somColisao.setGain(-10); // Aumenta o volume do som de colisão em 10 dB
 
 }

  if (somImpacto == null) {
    println("Erro ao carregar o som de impacto.");
  } else {
    println("Som de impacto carregado com sucesso.");
    somImpacto.setGain(-10); // Aumenta o volume do som de impacto em 10 dB
   
 }

  if (musicaFundo == null) {
    println("Erro ao carregar a música de fundo.");
  } else {
    println("Música de fundo carregada com sucesso.");
    musicaFundo.setGain(-35);
    musicaFundo.loop(); // Reproduz a música de fundo em loop
}
  
  jogo.escala = width * 0.7f / jogo.mesa.tamanho.x;
  if (jogo.escala * jogo.mesa.tamanho.y > height * 0.7f)
  {
    jogo.escala = height * 0.7f / jogo.mesa.tamanho.y;
  }
  jogo.translacao.def(width / 2, height / 2);
    
  cores.inicializar();
  
  textSize(16);
  
  
    //Imagem do fundo do menu
  img = loadImage("imagemmenu.jpg");
  Coord posicao = new Coord(0, 0); // Posição da imagem
  Coord tamanho = new Coord(width, height); // Tamanho da imagem
  int modo = GuiImagem.MODO_CORTAR; // Modo de exibição (MODO_ESTICAR, MODO_CORTAR, MODO_CABER)
  Coord alinhamento = new Coord(0.5, 0.5); // Alinhamento da imagem (0.5, 0.5 é centralizado)
  guiImagem = new GuiImagem(img, posicao, tamanho, modo, alinhamento);
  textSize (18);
  fill(255);
  textos = new ArrayList<String>();
  textos.add("História:\nRoberto, um  jovem estudante universitário, dedicado e determinado,\nestava sentindo o peso das responsabilidades acadêmicas.As longas horas de estudo,os trabalhos e as provas... ");
  textos.add("... estavam começando a cobrar seu preço. Depois de uma semana intensa de aulas e estudos, decidi que precisaria de uma pausa.Então resolveu jogar sinuca em um lugar conhecido como : ''Sinucão do...");
  textos.add("... Kleyson''. Em uma partida  conheceu Rafaela, agora Roberto quer impressionar essa garota .Precisa da sua ajuda!\nEscolha uma opção de jogo:");

  //Caixa de texto da História

  caixaDeTexto = new GuiCaixaDeTexto(textos.get(textoAtualIndex), new Coord(20, 20), new Coord(200, 200));
  //PAGINA INICIAL ========================================

  paginaInicial.camadas.add(guiImagem);
  //PAGINA INICIAL ========================================
  paginaInicial.camadas.add(new GuiRotulo("Sinucão do Kleyson", new Coord(495f, 300f)));
  paginaInicial.camadas.add(new GuiBotao("Corrida Contra o Tempo", loadImage("icone-cronometro.png"), new Coord(495f, 340f), new Coord(220f, 40f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      jogo.modoDeJogo = Jogo.MODO_CORRIDA_CONTRA_O_TEMPO;
      jogo.pausa = false;
      jogo.reiniciar();
      aplicacao.mudarPagina(paginaJogoCorridaContraTempo, false);
    }
  }));
  paginaInicial.camadas.add(new GuiBotao("Livre", loadImage("icone-zen.png"), new Coord(495f, 390f), new Coord(220f, 40f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      jogo.modoDeJogo = Jogo.MODO_LIVRE;
      jogo.pausa = false;
      jogo.reiniciar();
      aplicacao.mudarPagina(paginaJogoLivre, false);
    }
  }));
  
  paginaInicial.camadas.add(new GuiBotao("Dificuldade", new Coord(495f, 440f), new Coord(220f, 40f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      aplicacao.mudarPagina(paginaDificuldade, true);
    }
  }));
  
  //========================================================
  //Botão Tutorial
  paginaInicial.camadas.add(new GuiBotao("Como jogar", new Coord(495f, 490f), new Coord(220f, 40f), new GuiTratadorDeEventoBotao() {
    @Override
      void aoAcionar(GuiBotao botao)
    {
      aplicacao.mudarPagina(paginaJogoTutorial, true);
    }
  }
  ));
  //Créditos==================================================
  paginaInicial.camadas.add(new GuiBotao("Créditos", new Coord(495f,540f), new Coord(220f, 40f), new GuiTratadorDeEventoBotao() {
    @Override
      void aoAcionar(GuiBotao botao)
    {
      aplicacao.mudarPagina(paginaCreditos, true);
    }
  }
  ));


  //Caixa de texto história============================
  paginaInicial.camadas.add(caixaDeTexto);
  //===================================================

  //Botão anterior
  paginaInicial.camadas.add(new GuiBotao("Anterior", new Coord(20, 230), new Coord(80, 30), new GuiTratadorDeEventoBotao() {
    @Override
      void aoAcionar(GuiBotao botao) {
      if (textoAtualIndex > 0) {
        textoAtualIndex--;
        caixaDeTexto.atualizarTexto(textos.get(textoAtualIndex));
      }
    }
  }
  ));
  //======================================================
  //Botão Proximmo
  paginaInicial.camadas.add(new GuiBotao("Próximo", new Coord(145, 230), new Coord(80, 30), new GuiTratadorDeEventoBotao() {
    @Override
      void aoAcionar(GuiBotao botao) {
      if (textoAtualIndex < textos.size() - 1) {
        textoAtualIndex++;
        caixaDeTexto.atualizarTexto(textos.get(textoAtualIndex));
      }
    }
  }
  ));
  
   //<>//
  //PAGINA DIFICULDADE ====================================
  paginaDificuldade.camadas.add(guiImagem);
  paginaDificuldade.camadas.add(new GuiRotulo("Dificuldade", new Coord(495f, 270f)));
  GuiBotaoGrupoRadio grupoRadioDificuldade = new GuiBotaoGrupoRadio();
  GuiTratadorDeEventoBotao tratadorRadioDificuldade = new GuiTratadorDeEventoBotao() {
    @Override
    void aoEscolher(GuiBotao botao, int escolha)
    { //<>//
      jogo.definirDificuldade(escolha);
    }
  };
  paginaDificuldade.camadas.add(new GuiBotao("Facil", new Coord(495f, 300f), new Coord(200f, 30f), grupoRadioDificuldade, tratadorRadioDificuldade));
  grupoRadioDificuldade.atualizar(0);
  paginaDificuldade.camadas.add(new GuiBotao("Médio", new Coord(495f, 335f), new Coord(200f, 30f), grupoRadioDificuldade, tratadorRadioDificuldade));
  paginaDificuldade.camadas.add(new GuiBotao("Difícil", new Coord(495f, 370f), new Coord(200f, 30f), grupoRadioDificuldade, tratadorRadioDificuldade));
  paginaDificuldade.camadas.add(new GuiBotao("Voltar", new Coord(495f, 405f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      aplicacao.voltarPagina();
    }
  }));
  
  //PAGINA TUTORIAL =======================================
  paginaJogoTutorial.camadas.add(guiImagem);
  paginaJogoTutorial.camadas.add(new GuiFiltro(color(0, 0, 0, 200)));
  paginaJogoTutorial.camadas.add(new GuiRotulo("MODOS DE JOGO\n\n Modo de jogo 'Corrida Contra o Tempo':\n\n-Encaçape todas as bolas exceto a branca no menor tempo possível\n - Se encaçapar a bola branca, é fim de jogo!\n\n Modo de jogo 'Livre'\n Como não há jeito certo de jogar sinuca, esse modo permite que se \njogue como quiser.\n- Não há fim de jogo\nÉ possível recuperar qualquer bola encaçapada", new Coord(650f, 30f)));
  paginaJogoTutorial.camadas.add(new GuiRotulo("COMO JOGAR\n\nRealizar tacada:\n- Clique na bola branca para iniciar uma tacada\n- Use a roda do mouse para ajustar a força\n- Confira a quantidade de força que será aplicada a barra vertical no canto\n esquerdo\n- Mova o mouse para escolher a direção\n- Clique novamente para realizar a tacada\nObs.: Certifique-se de estar na ferramenta 'jogar'\n(botão de play no canto superior esquerdo)\n\nPausa:\n\n- Clique no botão de lista no canto superior esquerdopara pausar o jogo\n\nFerramenta 'mover':\n\n- Clique no botão de cruz no canto superior esquerdo da tela ou clique com o \nbotão direito em qualquer lugar para usar a usar a ferramenta 'mover'\n- Com a ferramenta 'mover', clique com o botão esquerdo paracomeçar a mover \na mesa e \nclique novamente para terminar.\n- Use a roda do mouse para ampliar ou reduzir o zoom\n- Use as teclas 'x' e 'z' para girar a mesa\n\nFerramenta 'posicionar bola   (modo de jogo 'livre'):\n\n\n- No modo de jogo 'livre', é possível 'posicionar bola'clicando no botão de mão\nno canto superior esquerdo.\n- Ao selecinar essa ferramenta, clique com o botãoesquerdo para mover uma bola\n- Clique novamente com o botão esquerdo quando terminar\n- Também é possível tirar bolas da mesa ou trazê-las de volta clicando na régua de bolas no topo da tela", new Coord(30f, 30f)));
  paginaJogoTutorial.camadas.add(new GuiBotao("Voltar", new Coord(1000f, 650f), new Coord(100f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
      void aoAcionar(GuiBotao botao)
    {
      aplicacao.voltarPagina();
      jogo.pausa = false;
    }
  }));

  //PAGINA CREDITOS =======================================
  paginaCreditos.camadas.add(guiImagem);
  paginaCreditos.camadas.add(new GuiFiltro(color(0, 0, 0, 200)));
  paginaCreditos.camadas.add(new GuiRotulo("Nomes dos integrantes:\n\n Danilo Leonardi Vieira \nLuca do Amaral Navas\nVinicius Baumann Ladosky\nVitória Santos Carvalho", new Coord(600f, 240f)));
  paginaCreditos.camadas.add(new GuiRotulo("Ra:\n\n202101494\n202109940\n202100270\n202113651", new Coord(475f, 240f)));
  paginaCreditos.camadas.add(new GuiBotao("Voltar", new Coord(550f, 400f), new Coord(90f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      aplicacao.voltarPagina();
    }
  }));
  
  GuiBotao botaoPausa = new GuiBotao(loadImage("icone-lista.png"), new Coord(10f, 10f), new Coord(30f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      jogo.pausa = true;
      aplicacao.abrirPopUp(paginaPausa);
    }
  });
  GuiBotao botaoFerramentaJogar = new GuiBotao(loadImage("icone-jogar.png"), new Coord(50f, 10f), new Coord(30f, 30f), grupoRadioFerramentas, tratadorRadioFerramentas);
  GuiBotao botaoFerramentaMover = new GuiBotao(loadImage("icone-mover.png"), new Coord(90f, 10f), new Coord(30f, 30f), grupoRadioFerramentas, tratadorRadioFerramentas);
  GuiBotao botaoFerramentaMoverBola = new GuiBotao(loadImage("icone-indicador.png"), new Coord(130f, 10f), new Coord(30f, 30f), grupoRadioFerramentas, tratadorRadioFerramentas);
  
  //PAGINA CORRIDA CONTRA O TEMPO =========================
  paginaJogoCorridaContraTempo.camadas.add(jogo);
  paginaJogoCorridaContraTempo.camadas.add(botaoPausa);
  paginaJogoCorridaContraTempo.camadas.add(botaoFerramentaJogar);
  paginaJogoCorridaContraTempo.camadas.add(botaoFerramentaMover);
  paginaJogoCorridaContraTempo.camadas.add(new GuiBolasForaDeJogo(new Coord(500f, 20f)));
  paginaJogoCorridaContraTempo.camadas.add(new GuiTempo(new Coord(200f, 20f)));
  paginaJogoCorridaContraTempo.camadas.add(new GuiPotenciaTacada(new Coord(15f, 100f), new Coord(20f, 400f)));

  //PAGINA LIVRE ==========================================
  paginaJogoLivre.camadas.add(jogo);
  paginaJogoLivre.camadas.add(botaoPausa);
  paginaJogoLivre.camadas.add(botaoFerramentaJogar);
  paginaJogoLivre.camadas.add(botaoFerramentaMover);
  paginaJogoLivre.camadas.add(botaoFerramentaMoverBola);
  paginaJogoLivre.camadas.add(new GuiBolasForaDeJogo(new Coord(500f, 20f)));
  paginaJogoLivre.camadas.add(new GuiPotenciaTacada(new Coord(15f, 100f), new Coord(20f, 400f)));
    
  //PAGINA PAUSA ==========================================
  paginaPausa.camadas.add(new GuiFiltro(color(0, 0, 0, 100)));
  paginaPausa.camadas.add(new GuiRotulo("Pausa", new Coord(20f, 200f)));
  paginaPausa.camadas.add(new GuiBotao("Continuar", new Coord(20f, 230f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      aplicacao.fecharPopUp();
      jogo.pausa = false;
    }
  }));
  paginaPausa.camadas.add(new GuiBotao("Reiniciar", new Coord(20f, 270f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      aplicacao.fecharPopUp();
      jogo.pausa = false;
      jogo.reiniciar();
    }
  }));
  paginaPausa.camadas.add(new GuiBotao("Sair", new Coord(20f, 310f), new Coord(200f, 30f), new GuiTratadorDeEventoBotao() {
    @Override
    void aoAcionar(GuiBotao botao)
    {
      aplicacao.mudarPagina(paginaInicial, false);
    }
  }));
  
  //PAGINA FIM DE JOGO ====================================
  paginaFimDeJogo.camadas.add(new GuiFiltro(color(0, 0, 0, 100)));
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
