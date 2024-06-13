Coord mouse()
{
  return new Coord(mouseX, mouseY);
}

float[] pontoPontoRetaABC(Coord A, Coord B)
{
  float[] abc = new float[3];
  abc[0] = A.y - B.y;
  abc[1] = B.x - A.x;
  abc[2] = -abc[0]*A.x -abc[1]*A.y;
  return abc;
}

boolean intercepcaoRetaReta(float[] abc0, float abc1[], int sentido, Coord saidaIntercepcao)
{
  float a0 = abc0[0], b0 = abc0[1], c0 = abc0[2];
  float a1 = abc1[0], b1 = abc1[1], c1 = abc1[2];
  
  float det = a0*b1 - b0*a1;
  
  if (det == 0f || (det > 0 && sentido < 0) || (det < 0 && sentido > 0))
    return false;
  
  float a00 = b1 / det;
  float a01 = -b0 / det;
  float a10 = -a1 / det;
  float a11 = a0 / det;
    
  saidaIntercepcao.x = a00 * -c0 + a01 * -c1;
  saidaIntercepcao.y = a10 * -c0 + a11 * -c1;

  return true;
}

boolean intercepcaoTrajetoriaBolaBola(Coord direcaoA, Coord posA, Coord posB, float raio, Coord saidaIntercepcao)
{  
  //se direcao da trajetoria for oposta a direcao entre as bolas: sair
  if (direcaoA.ponto(posB.sub(posA)) < 0)
    return false;
  
  //calcular ponto mais proximo da bola B na trajetória de A
  float m = direcaoA.y / direcaoA.x;  
  Coord p = new Coord();
  if (direcaoA.x == 0f)
  {
    p.x = posA.x;
  }
  else if (direcaoA.x == 1f)
  {
    p.x = posB.x;
  }
  else
  {
    p.x = (posB.x/m + posB.y + m*posA.x - posA.y) / (m + 1/m);
  }
  
  p.y = m*(p.x - posA.x) + posA.y;

  if (p.sub(posB).mag2() > 4f * raio * raio)
  {
    return false;
  }
  
  //caminhar ponto p na direção p -> A em {raio} unidades
  Coord q = new Coord();
  q = p.soma(posA.sub(p).unidade().mult(raio * 2f));
  
  //busca binária por colisão bola x bola entre p e q
  Coord r = p.soma(q).div(2);
  for (int i = 0; i < 15; i++)
  {
    float erro = r.sub(posB).mag() - raio * 2f;
    if (abs(erro) < 0.001)
    {
      break;
    }
    else if (erro > 0)
    {
      q = r;
    }
    else
    {
      p = r;
    }
    r = p.soma(q).div(2);
  }
  
  saidaIntercepcao.def(r);
  return true;
}
