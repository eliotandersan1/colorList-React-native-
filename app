import React,{Component} from 'react'
import{
  StyleSheet,
    ListView,
    AsyncStorage

  } from 'react-native';

import ColorButton from './components/colorButton';
import ColorForm from './components/colorForm';

export default class  App extends React.Component<{}>{

    constructor(){
        super()
            this.ds = new ListView.DataSource({
                rowHasChanged:(r1,r2) => r1!=r2
            });
            const availableColors = [];

            this.state = {backgroundColor: 'pink',
                          availableColors,
                          dataSource:this.ds.cloneWithRows(availableColors)
                };

            this.changeBackgroundColor = this.changeBackgroundColor.bind(this)
            this.newColor = this.newColor.bind(this);
          }
          //to save the colors even after reload
    componentDidMount(){

        AsyncStorage.getItem(
            '@colorsListStore:colors',
            (err,data) =>{
                if(err){
                    console.error('Error while loading the colors',err)
                }else{
                    const availableColors = JSON.parse(data);
                    this.setState({
                        availableColors,
                        dataSource: this.ds.cloneWithRows(availableColors)
                    });
                }
            }
        )
    }

          //async storage
    saveColors(colors){
        AsyncStorage.setItem(
            '@colorsListStore:colors',
            JSON.stringify(colors)
        )
    }



    changeBackgroundColor(backgroundColor){
        this.setState({backgroundColor});
    }

    newColor(color) { // add colors form method
        const availableColors = [
        ...this.state.availableColors,
            color
        ]
        this.setState({
            availableColors,
            dataSource: this.ds.cloneWithRows(availableColors)
        })
        this.saveColors(availableColors)
    }
  render(){
       const {backgroundColor,dataSource} = this.state;
    return(
        <ListView style={[styles.container, {backgroundColor}]}
                  dataSource={dataSource}
                  renderRow={(color) =>(
                      <ColorButton backgroundColor={color}
                      onSelect ={this.changeBackgroundColor}/>
                  )}
                renderHeader ={() =>
                   <ColorForm onNewColor={this.newColor}/>
                  }>

        </ListView>

    )
  }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,

    },
    header:{
        backgroundColor:'lightgrey',
        paddingTop:20,
        padding:10,
        fontSize:30,
        textAlign:'center'
    }
});
