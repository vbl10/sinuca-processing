import java.util.ArrayList;

//unidade de distância:  cm
//unidade de tempo:      s

float jogoEscala = 1.0f;

Mesa mesa = new Mesa(new Coord(254.0f, 127.0f), 3.7f, 20.0f);

Bola bolas[] = new Bola[16];
boolean semMovimento = true;
boolean preparandoTacada = false;

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
}

Coord mouseCoordMundo()
{
  return new Coord((mouseX - width / 2) / jogoEscala, (mouseY - height / 2) / jogoEscala);
}
void mousePressed()
{
  if (semMovimento)
  {
    if (mouseButton == LEFT)
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
        if (bolas[i].pos.x - Bola.raio < -mesa.tamanho.x / 2)
        {
          bolas[i].pos.x = -mesa.tamanho.x / 2 + Bola.raio;
          bolas[i].vel.x = -bolas[i].vel.x;
        }
        else if (bolas[i].pos.x + Bola.raio > mesa.tamanho.x / 2)
        {
          bolas[i].pos.x = mesa.tamanho.x / 2 - Bola.raio;
          bolas[i].vel.x = -bolas[i].vel.x;
        }
        
        if (bolas[i].pos.y - Bola.raio < -mesa.tamanho.y / 2)
        {
          bolas[i].pos.y = -mesa.tamanho.y / 2 + Bola.raio;
          bolas[i].vel.y = -bolas[i].vel.y;
        }
        else if (bolas[i].pos.y + Bola.raio > mesa.tamanho.y / 2)
        {
          bolas[i].pos.y = mesa.tamanho.y / 2 - Bola.raio;
          bolas[i].vel.y = -bolas[i].vel.y;
        }
        
        //colisão com caçapa
        for (int j = 0; j < 6; j++)
        {
          if (bolas[i].pos.sub(mesa.cacapas[j]).mag() < mesa.cacapaRaio)
          {
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
        for (int j = 0; j < bolas.length; j++)
        {
          if (i != j && bolas[j].estaEmJogo)
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
              
              Coord q = jiUn.mult(bolas[i].vel.ponto(jiUn) - bolas[j].vel.ponto(jiUn));
              bolas[i].vel = bolas[i].vel.sub(q);
              bolas[j].vel = bolas[j].vel.soma(q);
            }
          }
        }
      }
    }
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
      
  //desenhar tacada
  if (preparandoTacada)
  {
    Coord mouse = mouseCoordMundo();
    stroke(255, 0, bolas[0].pos.sub(mouseCoordMundo()).mag() > 70.0f ? 255 : 0);
    line(bolas[0].pos.x, bolas[0].pos.y, mouse.x, mouse.y);
  }

  popMatrix();
  
  //medir tempo de geração desse quadro
  tp2 = millis();
  dt = (float)(tp2 - tp1) / 1000.0f;
  tp1 = millis();
}
