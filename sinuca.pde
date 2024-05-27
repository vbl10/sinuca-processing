import java.util.ArrayList;

float jogoEscala = 1.0f;
final Coord mesaTamanho = new Coord(254.0f, 127.0f); // cm x cm
final float mesaAtritoAcel = 20.0f; // cm/s²

Bola bolas[] = new Bola[16];
boolean semMovimento = true;
boolean preparandoTacada = false;

void posicionarBolas()
{
  bolas[0].pos.x = -mesaTamanho.x / 4;
  bolas[0].pos.y = 0.0f;
  
  // 1, 2, 3, 4
  // 1, 3, 6, 10
  
  
  ArrayList<Coord> posicoes = new ArrayList();
  float x = mesaTamanho.x / 4;
  float y = 0.0f;
  for (int i = 0, k = 1; i < 5; i++)
  {
    float yj = y;
    for (int j = 0; j < i + 1; j++, k++)
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
  
  jogoEscala = width * 0.7f / mesaTamanho.x;
  if (jogoEscala * mesaTamanho.y > height * 0.7f)
  {
    jogoEscala = height * 0.7f / mesaTamanho.y;
  }
  
  for (int i = 0; i < bolas.length; i++) bolas[i] = new Bola();
  
  bolas[0].cor = color(255, 255, 255);
  bolas[1].cor = color(255, 255, 000);
  bolas[2].cor = color(000, 000, 255);
  bolas[3].cor = color(255, 000, 000);
  bolas[4].cor = color(128, 000, 128);
  bolas[5].cor = color(255, 165, 000);
  bolas[6].cor = color(000, 128, 000);
  bolas[7].cor = color(128, 000, 000);
  bolas[8].cor = color(000, 000, 000);
  bolas[9].cor = color(255, 255, 000);
  bolas[10].cor = color(000, 000, 255);
  bolas[11].cor = color(255, 000, 000);
  bolas[12].cor = color(128, 000, 128);
  bolas[13].cor = color(255, 165, 000);
  bolas[14].cor = color(000, 128, 000);
  bolas[15].cor = color(128, 000, 000);
  
  posicionarBolas();
}


int tp1 = 0, tp2 = 0; 
float dt = 0.0f;

void draw()
{
  //bolas[0].pos.x = (mouseX - width / 2) / jogoEscala;
  //bolas[0].pos.y = (mouseY - height / 2) / jogoEscala;
  
  dt /= 10;
  for (int passo = 0; passo < 10; passo++)
  {
    boolean semMovimentoTmp = true;
    //atualizar pos com vel e colisao bola x mesa
    for (int i = 0; i < bolas.length; i++)
    {
      if (bolas[i].vel.mag() != 0.0f)
      {
        semMovimentoTmp = false;

        bolas[i].pos = bolas[i].pos.soma(bolas[i].vel.mult(dt));
        bolas[i].vel = bolas[i].vel.unidade().mult(max(0.0f, bolas[i].vel.mag() - mesaAtritoAcel * dt));
        
        if (bolas[i].pos.x - Bola.raio < -mesaTamanho.x / 2)
        {
          bolas[i].pos.x = -mesaTamanho.x / 2 + Bola.raio;
          bolas[i].vel.x = -bolas[i].vel.x;
        }
        else if (bolas[i].pos.x + Bola.raio > mesaTamanho.x / 2)
        {
          bolas[i].pos.x = mesaTamanho.x / 2 - Bola.raio;
          bolas[i].vel.x = -bolas[i].vel.x;
        }
        
        if (bolas[i].pos.y - Bola.raio < -mesaTamanho.y / 2)
        {
          bolas[i].pos.y = -mesaTamanho.y / 2 + Bola.raio;
          bolas[i].vel.y = -bolas[i].vel.y;
        }
        else if (bolas[i].pos.y + Bola.raio > mesaTamanho.y / 2)
        {
          bolas[i].pos.y = mesaTamanho.y / 2 - Bola.raio;
          bolas[i].vel.y = -bolas[i].vel.y;
        }
      }
    }
    
    semMovimento = semMovimentoTmp;
    if (semMovimento)
      break;
    
    //colisao bola x bola
    for (int i = 0; i < bolas.length; i++)
    {
      for (int j = 0; j < bolas.length; j++)
      {
        if (i != j)
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
  
  //desenhar
  background(40,40,40);
  
  pushMatrix();
  translate(width / 2, height / 2);
  scale(jogoEscala);
  
  //desenhar mesa
  fill(30, 57, 12);
  strokeWeight(20);
  stroke(54, 32, 12);
  rect(-mesaTamanho.x / 2, -mesaTamanho.y / 2, mesaTamanho.x, mesaTamanho.y, 1.0f);
  strokeWeight(1);
  rect(-mesaTamanho.x / 2, -mesaTamanho.y / 2, mesaTamanho.x, mesaTamanho.y, 1.0f);
  
  //dessenhar bolas
  strokeWeight(0.5);
  for (int i = 0; i < bolas.length; i++)
  {
    fill(bolas[i].cor);
    if (i < 9) stroke(bolas[i].cor);
    else stroke(255, 255, 255);
    circle(bolas[i].pos.x, bolas[i].pos.y, Bola.raio * 2);
  }
  
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
