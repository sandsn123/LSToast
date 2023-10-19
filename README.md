## Requirements
- Xcode 12.x
- Swift 5.x


## Installation

### [Swift Package Manager (SPM)](https://github.com/sandsn123/LSToast.git#swift-package-manager-spm)

1. File -> Swift Packages -> Add Package Dependency...
2. Enter package URL :https://github.com/sandsn123/LSToast.git, choose the latest release

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
<th>Add ```.toast(with: _toast)```  at the end of the view you want to show toast.</th>
<tr>
<td valign="top">
<pre lang="Swift">
    ZStack { ... }.toast(with: _toast)
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



**Used in ObservableObject:**

<table width="100%">
<th>use @ToastPublished.</th>
<tr>
<td valign="top">
<pre lang="Swift">
 class DemoModel: ObservableObject {
    @ToastPublished([
        .complete(titleColor: .blue)
    ]) var toast
}
struct DemoView: View {
	 var body: some View {
				// your view
			 .toast(with: $vm.toast, config: vm.$toast.config)
	 }
}
</pre>
</td>
</tr>
</table>


![](https://media.giphy.com/media/00tJvWPXnTL0rS7DVH/giphy.gif)

![](https://media.giphy.com/media/ddxyLH0XufB66Iciw6/giphy.gif)
