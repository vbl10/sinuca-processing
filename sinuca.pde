import java.util.ArrayList;

class Coord
{
  public float x, y;
  Coord(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  Coord() 
  {
    this.x = 0.0f;
    this.y = 0.0f;
  }
  
  float mag2()
  {
    return this.x * this.x + this.y * this.y;
  }
  float mag()
  {
    return sqrt(this.mag2());
  }
  Coord unidade()
  {
    return this.div(this.mag());
  }
  
  float ponto(Coord b)
  {
    return this.x * b.x + this.y * b.y;
  }
  Coord soma(Coord b)
  {
    return new Coord(this.x + b.x, this.y + b.y);
  }
  Coord sub(Coord b)
  {
    return new Coord(this.x - b.x, this.y - b.y);
  }
  Coord mult(float b)
  {
    return new Coord(this.x * b, this.y * b);
  }
  Coord div(float b)
  {
    return new Coord(this.x / b, this.y / b);
  }
};
class Bola
{
  public static final float raio = 2.7f; //cm
  Coord pos, vel;
  boolean estaEmJogo;
  
  color cor;
  
  Bola()
  {
    this.estaEmJogo = true;
    this.pos = new Coord();
    this.vel = new Coord();
    cor = color(0);
  }
};

float jogoEscala = 1.0f;

final Coord mesaTamanho = new Coord(254.0f, 127.0f); // cm x cm

Bola bolas[] = new Bola[16];
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
  dt /= 10;
  for (int passo = 0; passo < 10; passo++)
  {
    //atualizar pos com vel e colisao bola x mesa
    for (int i = 0; i < bolas.length; i++)
    {
      bolas[i].pos = bolas[i].pos.soma(bolas[i].vel.mult(dt));
      
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
            
            bolas[i].pos.x += corr.x;
            bolas[i].pos.y += corr.y;
            
            bolas[j].pos.x -= corr.x;
            bolas[j].pos.y -= corr.y;
          }
        }
      }
    }
  }
  
  //desenhar
  background(0);
  
  pushMatrix();
  translate(width / 2, height / 2);
  scale(jogoEscala);
  
  //desenhar mesa
  fill(0, 50, 0);
  strokeWeight(1);
  stroke(0, 70, 0);
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

  popMatrix();
  
  //medir tempo de geração desse quadro
  tp2 = millis();
  dt = (float)(tp2 - tp1) / 1000.0f;
  tp1 = millis();
}
