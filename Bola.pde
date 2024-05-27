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
