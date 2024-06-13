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
  public void desenhar(boolean posicaoValida)
  {
    color cor = posicaoValida ? color(255) : color(180);
    fill(cor);
    circle(pos.x, pos.y, Bola.raio * 2);    
  }
};
