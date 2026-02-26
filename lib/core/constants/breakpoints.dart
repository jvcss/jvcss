class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
}

double sphereSize(double screenWidth) {
  if (screenWidth < Breakpoints.mobile) return 40;
  if (screenWidth < Breakpoints.tablet) return 50;
  return 64;
}

double orbitRadius(double screenWidth) {
  if (screenWidth < Breakpoints.mobile) return 60;
  if (screenWidth < Breakpoints.tablet) return 80;
  return 100;
}
