try {
  await import('./game.js?v=1dee3ac21c3c');
  document.querySelector('#loadingScreen').hidden=true;
} catch(error) {
  document.querySelector('#loadingScreen').hidden=true;
  document.querySelector('#runtimeError').hidden=false;
  console.error('APEX CLUB startup failed:',error);
}
