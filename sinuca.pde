import java.util.ArrayList;

//unidade de distância:  cm
//unidade de tempo:      s

float jogoEscala = 1.0f;

Mesa mesa = new Mesa(new Coord(254.0f, 127.0f), 3.7f, 20.0f);

Bola bolas[] = new Bola[16];
boolean semMovimento = true;
boolean preparandoTacada = false;
boolean posicionandoBolaBranca = false;
boolean posicionandoBolaBrancaValido = false;

void posicionarBolas()
{
  bolas[0].pos.x = -mesa.tamanho.x / 4;
  bolas[0].pos.y = 0.0f;
  
  // 1, 2, 3, 4
  // 1, 3, 6, 10
  
  
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

Coord mouseCoordMundo()
{
  return new Coord((mouseX - width / 2) / jogoEscala, (mouseY - height / 2) / jogoEscala);
}
void mousePressed()
{
  if (mouseButton == LEFT)
  {
    if (posicionandoBolaBranca && posicionandoBolaBrancaValido)
    {
      posicionandoBolaBranca = false;
      bolas[0].estaEmJogo = true;
      bolas[0].vel.def(0f, 0f);
    }
    else if (semMovimento)
    {
      Coord mouse = mouseCoordMundo();
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
}
void keyPressed()
{
  if (key == 'r')
  {
    posicionarBolas();
  }
}

void setup()
{
  size(1200, 800);
  
  jogoEscala = width * 0.7f / mesa.tamanho.x;
  if (jogoEscala * mesa.tamanho.y > height * 0.7f)
  {
    jogoEscala = height * 0.7f / mesa.tamanho.y;
  }
  
  for (int i = 0; i < bolas.length; i++) bolas[i] = new Bola();
  
  posicionarBolas();
  
  cores.inicializar();
}


int tp1 = 0, tp2 = 0; 
float dt = 0.0f;

void draw()
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
  
  if (semMovimento && posicionandoBolaBranca)
  {
    posicionandoBolaBrancaValido = true;
    Bola nBola = new Bola();
    nBola.pos.def(mouseCoordMundo());
    
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
  
  //desenhar
  background(40,40,40);
  
  pushMatrix();
  translate(width / 2, height / 2);
  scale(jogoEscala);
  
  mesa.desenhar();

  //dessenhar bolas
  for (int i = 0; i < bolas.length; i++)
    if (bolas[i].estaEmJogo)
      bolas[i].desenhar(i);
      
  if (posicionandoBolaBranca && semMovimento)
  {
    bolas[0].desenhar(posicionandoBolaBrancaValido);
  }
      
  //desenhar tacada
  if (preparandoTacada)
  {
    Coord mouse = mouseCoordMundo();
    strokeWeight(1);
    stroke(255, 0, bolas[0].pos.sub(mouseCoordMundo()).mag() > 70.0f ? 255 : 0);
    line(bolas[0].pos.x, bolas[0].pos.y, mouse.x, mouse.y);
    
  }

  popMatrix();
  
  //medir tempo de geração desse quadro
  tp2 = millis();
  dt = (float)(tp2 - tp1) / 1000.0f;
  tp1 = millis();
}
