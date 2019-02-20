/* eslint react/prop-types: 0 */
import React, { Component } from 'react';
import logo from './logo-ve.png';
import './App.css';

class App extends Component {
  render() {
    return (

      <div className="App">
        <head>
        </head>
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
        </header>
        <p>
            Welcome to the VisualEyes client website.
        </p>
        

      </div>
      
    );
  }
}

export default App;
