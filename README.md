## Usage

**LSToast** easy way to show toast in SwitUI:

<table width="100%">
<th>Add ```@Toast var toast``` in your SwiftUI view</th>
<tr>
<td valign="top">
<pre lang="Swift">
    struct ContentView: View {     
        //  custom style
        //  @Toast([
            // regiular message
            // .message(titleColor: .blue, textColor: .red),
            // loading
            // .loading(tintColor: .blue)
        //  ])
         @Toast var toast  // default      
         ...
    }
</pre>
</td>
</tr>
</table>



<table width="100%">
<th>Add ```.toast(with: _toast)```  at the end of the view you want to show toast.</th>
<tr>
<td valign="top">
<pre lang="Swift">
    ZStack { ... }
			.toast(with: _toast)
</pre>
</td>
</tr>
</table>

<table width="100%">
<th>Assign a value to toast.</th>
<tr>
<td valign="top">
<pre lang="Swift">
    toast = .loading("Loading..."),
    // toast = .mesage("title", text: "text"),
</pre>
</td>
</tr>
</table>

![](https://media.giphy.com/media/00tJvWPXnTL0rS7DVH/giphy.gif)

![](https://media.giphy.com/media/ddxyLH0XufB66Iciw6/giphy.gif)