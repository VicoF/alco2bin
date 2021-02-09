import logo from './logo.svg';
import './App.css';
import React, {useEffect, useState} from 'react';

function App(props){
  const [switches, setSwitches] = useState("inconnu");



  const updateSwitches = () => {
    const http = new XMLHttpRequest();
    const url = 'http://192.168.1.10/cmd/sws';

    http.open("GET", url);
    http.send();
    http.onload = () => setSwitches(http.responseText);
  }
  
  useEffect(()=> setInterval( () => updateSwitches(), 10), []);
  
    return (
        <div className="App">
          <header className="App-header">
            <img src={logo} className="App-logo" alt="logo" />
            <p>Hello!</p>

            <p>L'état des interrupteurs est : </p>
            <b><p id="switches">{switches}</p></b>

          </header>
        </div>
    );
  }

export default App;
