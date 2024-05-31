class Jogo
{
  public float escala = 1f;
  public Coord translacao = new Coord();
  public float rotacao = 0f;

  private Bola bolas[] = new Bola[16];
  private boolean semMovimento = true;
  private boolean preparandoTacada = false;
  private boolean posicionandoBolaBranca = false;
  private boolean posicionandoBolaBrancaValido = false;

  Mesa mesa = new Mesa(new Coord(254.0f, 127.0f), 3.7f, 20.0f);

  Jogo()
  {
    for (int i = 0; i < bolas.length; i++) bolas[i] = new Bola();
    reiniciar();
  }

  Matriz matriz()
  {
    return 
      matrizIdentidade()
      .mult(matrizTranslacao(translacao))
      .mult(matrizEscala(new Coord(escala, escala)))
      .mult(matrizRotacao(rotacao))
      ;
  }

  Coord telaParaMundo(Coord coordTela)
  {
    return matriz().inversa().mult(coordTela);
  }
  
  Coord mundoParaTela(Coord coordMundo)
  {
    return matriz().mult(coordMundo);
  }

  Coord mouseParaMundo()
  {
    return telaParaMundo(new Coord(mouseX, mouseY));
  }
  
  void aplicarMatriz()
  {
    translate(translacao.x, translacao.y);
    scale(escala);
    rotate(rotacao);
  }
  
  public void aoMoverMouse()
  {
    if (semMovimento && posicionandoBolaBranca)
    {
      checarPosicaoBolaValida();
    }
  }
  public void aoClicarMouse()
  {
    if (posicionandoBolaBranca)
    {
      if (posicionandoBolaBrancaValido)
      {
        posicionandoBolaBranca = false;
        bolas[0].estaEmJogo = true;
        bolas[0].vel.def(0f, 0f);
      }
    }
    else if (semMovimento)
    {
      Coord mouse = mouseParaMundo();
      if (mouse.sub(bolas[0].pos).mag() < Bola.raio)
      {
        preparandoTacada = !preparandoTacada;
      }
      else if (preparandoTacada)
      {
        preparandoTacada = false;
        Coord mouseBola = bolas[0].pos.sub(mouse);
        bolas[0].vel = mouseBola.unidade().mult(min(200.0f, max(10.0f, map(mouseBola.mag(), 10.0f, 70.0f, 1.0f, 200.0f))));
      }
    }
  }

  private void checarPosicaoBolaValida()
  {
    posicionandoBolaBrancaValido = true;
    Bola nBola = new Bola();
    nBola.pos.def(mouseParaMundo());
    
    // colisão com mesa
    if (mesa.colideComEsq(nBola))
        nBola.pos.x = -mesa.tamanho.x / 2 + Bola.raio;
    else if (mesa.colideComDir(nBola))
        nBola.pos.x = mesa.tamanho.x / 2 - Bola.raio;
    
    if (mesa.colideComSup(nBola))
        nBola.pos.y = -mesa.tamanho.y / 2 + Bola.raio;
    else if (mesa.colideComInf(nBola))
        nBola.pos.y = mesa.tamanho.y / 2 - Bola.raio;    
        
    //colisão com caçapa
    for (int j = 0; j < 6; j++)
    {
    Coord vCB = nBola.pos.sub(mesa.cacapas[j]);
    float magCB = vCB.mag();
    Coord unCB = vCB.div(magCB);
    if (magCB < mesa.cacapaRaio)
    {
        nBola.pos = nBola.pos.soma(unCB.mult(mesa.cacapaRaio - magCB));
        break;
    }
    }
    
    //colisao nBola x bola
    for (int i = 0; i < bolas.length; i++)
    {
    if (bolas[i].estaEmJogo)
    {
        Coord vIB = nBola.pos.sub(bolas[i].pos);
        if (vIB.mag() < Bola.raio * 2)
        {
        posicionandoBolaBrancaValido = false;
        break;
        }
    }
    }
    
    bolas[0].pos.def(nBola.pos);
  }

  void reiniciar()
  {
    bolas[0].pos.x = -mesa.tamanho.x / 4;
    bolas[0].pos.y = 0.0f;
    
    ArrayList<Coord> posicoes = new ArrayList();
    float x = mesa.tamanho.x / 4;
    float y = 0.0f;
    for (int i = 0; i < 5; i++)
    {
      float yj = y;
      for (int j = 0; j < i + 1; j++)
      {
        posicoes.add(new Coord(x, yj));
        yj += Bola.raio * 2;
      }
      x += cos(PI / 6) * Bola.raio * 2;
      y -= sin(PI / 6) * Bola.raio * 2;
    }
    
    bolas[8].pos = posicoes.get(4);
    posicoes.remove(4);
    
    bolas[1].pos = posicoes.get(0);
    posicoes.remove(0);

    for (int i = 2; i < 8; i++)
    {
      int j = (int)random(posicoes.size() - 0.1);
      bolas[i].pos = posicoes.get(j);
      posicoes.remove(j);
    }
    for (int i = 9; i < 16; i++)
    {
      int j = (int)random(posicoes.size() - 0.1);
      bolas[i].pos = posicoes.get(j);
      posicoes.remove(j);
    }
    for (int i = 0; i < 16; i++)
    {
      bolas[i].vel.def(0.0f, 0.0f);
      bolas[i].estaEmJogo = true;
    }
  }


  void atualizar(float dt)
  {
    dt /= 10;
    for (int passo = 0; passo < 10; passo++)
    {
      boolean semMovimentoTmp = true;
      //atualizar pos com vel e colisao bola x mesa
      for (int i = 0; i < bolas.length; i++)
      {
        if (bolas[i].estaEmJogo && bolas[i].vel.mag() != 0.0f)
        {
          semMovimentoTmp = false;
  
          // atualizar posição e velocidade
          bolas[i].pos = bolas[i].pos.soma(bolas[i].vel.mult(dt));
          bolas[i].vel = bolas[i].vel.unidade().mult(max(0.0f, bolas[i].vel.mag() - mesa.atritoAcel * dt));
          
          // colisão com mesa
          if (mesa.colideComEsq(bolas[i]))
          {
            bolas[i].pos.x = -mesa.tamanho.x / 2 + Bola.raio;
            bolas[i].vel.x = -bolas[i].vel.x;
          }
          else if (mesa.colideComDir(bolas[i]))
          {
            bolas[i].pos.x = mesa.tamanho.x / 2 - Bola.raio;
            bolas[i].vel.x = -bolas[i].vel.x;
          }
          
          if (mesa.colideComSup(bolas[i]))
          {
            bolas[i].pos.y = -mesa.tamanho.y / 2 + Bola.raio;
            bolas[i].vel.y = -bolas[i].vel.y;
          }
          else if (mesa.colideComInf(bolas[i]))
          {
            bolas[i].pos.y = mesa.tamanho.y / 2 - Bola.raio;
            bolas[i].vel.y = -bolas[i].vel.y;
          }
          
          //colisão com caçapa
          for (int j = 0; j < 6; j++)
          {
            if (bolas[i].pos.sub(mesa.cacapas[j]).mag() < mesa.cacapaRaio)
            {
              if (i == 0)
                posicionandoBolaBranca = true;
  
              bolas[i].estaEmJogo = false;
            }
          }
        }
      }
      
      semMovimento = semMovimentoTmp;
      if (semMovimento)
        break;
      
      //colisao bola x bola
      for (int i = 0; i < bolas.length; i++)
      {
        if (bolas[i].estaEmJogo)
        {
          for (int j = i + 1; j < bolas.length; j++)
          {
            if (bolas[j].estaEmJogo)
            {
              Coord ji = bolas[i].pos.sub(bolas[j].pos);
              float jiMag = ji.mag();
              if (jiMag < Bola.raio * 2)
              {
                Coord jiUn = ji.div(jiMag); 
                float corrMag = (Bola.raio - jiMag / 2);
                Coord corr = jiUn.mult(corrMag);
    
                bolas[i].pos = bolas[i].pos.soma(corr);
                bolas[j].pos = bolas[j].pos.sub(corr);
                
                Coord q = jiUn.mult(bolas[i].vel.sub(bolas[j].vel).ponto(jiUn));
                bolas[i].vel = bolas[i].vel.sub(q);
                bolas[j].vel = bolas[j].vel.soma(q);
              }
            }
          }
        }
      }
    }
  }
  
  void desenhar()
  {
    pushMatrix();
    aplicarMatriz();
    
    mesa.desenhar();
  
    //dessenhar bolas
    for (int i = 0; i < bolas.length; i++)
      if (bolas[i].estaEmJogo)
        bolas[i].desenhar(i);
        
    if (ferramenta == FERRAMENTA_JOGAR)
    {
      if (posicionandoBolaBranca && semMovimento)
      {
        bolas[0].desenhar(posicionandoBolaBrancaValido);
      }
          
      //desenhar tacada
      if (preparandoTacada)
      {
        Coord mouse = mouseParaMundo();
        strokeWeight(1);
        stroke(255, 0, bolas[0].pos.sub(mouse).mag() > 70.0f ? 255 : 0);
        line(bolas[0].pos.x, bolas[0].pos.y, mouse.x, mouse.y);
        
      }
    }
  
    popMatrix();
    
  }
}
