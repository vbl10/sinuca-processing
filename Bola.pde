class Bola
{
  public static final float raio = 2.7f; //cm
  Coord pos, vel;
  boolean estaEmJogo;
    
  Bola()
  {
    this.estaEmJogo = true;
    this.pos = new Coord();
    this.vel = new Coord();
  }
  
  public void desenhar(int numero)
  {
    noStroke();
    if (numero < 9)
    {
      fill(cores.bola[numero]);
      circle(pos.x, pos.y, Bola.raio * 2);
    }
    else
    {
      fill(255, 255, 255);
      circle(pos.x, pos.y, Bola.raio * 2);
      fill(cores.bola[numero]);
      circle(pos.x, pos.y, Bola.raio * 2 - 1);      
    }
  }
  public void desenhar(int numero, boolean posicaoValida)
  {
    if (!posicaoValida)
    {
      fill(255, 0, 0);
      circle(pos.x, pos.y, Bola.raio * 2 + 1);
    }
    fill(cores.bola[numero]);
    circle(pos.x, pos.y, Bola.raio * 2);    
  }
};

void desenharBola(int numero, Coord centro, float raio)
{
  pushMatrix();
  translate(centro.x, centro.y);
  scale(raio / Bola.raio);
  noStroke();
  if (numero < 9)
  {
    fill(cores.bola[numero]);
    circle(0, 0, Bola.raio * 2);
  }
  else
  {
    fill(255, 255, 255);
    circle(0, 0, Bola.raio * 2);
    fill(cores.bola[numero]);
    circle(0, 0, Bola.raio * 2 - 1);      
  }
  popMatrix();
}
