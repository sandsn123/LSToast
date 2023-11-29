## Requirements
- Xcode 13.x
- Swift 5.x


## Installation

### [Swift Package Manager (SPM)](https://gitee.com/sandsn123/LSToast.git#swift-package-manager-spm)

1. File -> Swift Packages -> Add Package Dependency...
2. Enter package URL :https://gitee.com/sandsn123/LSToast.git, choose the latest release

## Usage

**LSToast** easy way to show toast in SwitUI:

**Used in view:**

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
<th>Add ```.toast(with: $toast)```  at the end of the view you want to show toast.</th>
<tr>
<td valign="top">
<pre lang="Swift">
    ZStack { ... }.toast(with: $toast)
</pre>
</td>
</tr>
</table>
<table width="100%">
<th>Assign a value to toast.</th>
<tr>
<td valign="top">
<pre lang="Swift">
    toast(.loading(.large, "Loading..."))
    // toast(.mesage("title", text: "text"))
</pre>
</td>
</tr>
</table>



**Used in ObservableObject:**

<table width="100%">
<th>Used in ObservableObject</th>
<tr>
<td valign="top">
<pre lang="Swift">
 class DemoModel: ObservableObject {
    @ToastProvider([
        .complete(titleColor: .blue)
    ]) var toast
}
struct DemoView: View {
	 var body: some View {
				// your view
			 .toast(with: $vm.toast)
	 }
}
</pre>
</td>
</tr>
</table>


![](https://media.giphy.com/media/00tJvWPXnTL0rS7DVH/giphy.gif)

![](https://media.giphy.com/media/ddxyLH0XufB66Iciw6/giphy.gif)
