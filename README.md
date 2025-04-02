<h1 class="code-line" data-line-start=0 data-line-end=1 ><a id="HealthKit_Swift_Demo_0"></a>HealthKit Swift Demo</h1>
<p class="has-line-data" data-line-start="2" data-line-end="3">This demo app showcases how to integrate Apple’s HealthKit framework in an iOS application. It allows reading health data, such as step count, heart rate, walking/running distance, and body mass.</p>

<img src="./preview.gif" width="50%" height="50%"/>


<h2 class="code-line" data-line-start=4 data-line-end=5 ><a id="Features_4"></a>Features</h2>
<ul>
<li class="has-line-data" data-line-start="6" data-line-end="7">Request permissions to access HealthKit data</li>
<li class="has-line-data" data-line-start="7" data-line-end="8">Read health data from HealthKit</li>
<li class="has-line-data" data-line-start="8" data-line-end="10">Display retrieved health metrics in the app</li>
</ul>
<h2 class="code-line" data-line-start=10 data-line-end=11 ><a id="Health_Data_Types_Used_10"></a>Health Data Types Used</h2>
<p class="has-line-data" data-line-start="12" data-line-end="13">This demo reads the following HealthKit quantity types:</p>
<ul>
<li class="has-line-data" data-line-start="13" data-line-end="14">Step Count (HKQuantityTypeIdentifier.stepCount)</li>
<li class="has-line-data" data-line-start="14" data-line-end="15">Heart Rate (HKQuantityTypeIdentifier.heartRate)</li>
<li class="has-line-data" data-line-start="15" data-line-end="16">Walking/Running Distance (HKQuantityTypeIdentifier.distanceWalkingRunning)</li>
<li class="has-line-data" data-line-start="16" data-line-end="18">Body Mass (HKQuantityTypeIdentifier.bodyMass)</li>
</ul>
<h2 class="code-line" data-line-start=18 data-line-end=19 ><a id="Requirements_18"></a>Requirements</h2>
<ul>
<li class="has-line-data" data-line-start="20" data-line-end="21">Xcode 13 or later</li>
<li class="has-line-data" data-line-start="21" data-line-end="22">iOS 13 or later</li>
<li class="has-line-data" data-line-start="22" data-line-end="23">A physical device with HealthKit support (some features may not work on the simulator)</li>
<li class="has-line-data" data-line-start="23" data-line-end="25">HealthKit enabled in the app’s capabilities</li>
</ul>
<h2 class="code-line" data-line-start=25 data-line-end=26 ><a id="Setup_25"></a>Setup</h2>
<ol>
<li class="has-line-data" data-line-start="27" data-line-end="28">Clone this repository:</li>
</ol>
<pre><code class="has-line-data" data-line-start="29" data-line-end="31" class="language-sh">     git <span class="hljs-built_in">clone</span> https://github.com/skety777/healthkit-swift.git
</code></pre>
<ol start="2">
<li class="has-line-data" data-line-start="31" data-line-end="32">Open the project in Xcode.</li>
<li class="has-line-data" data-line-start="32" data-line-end="33">Enable HealthKit in Signing &amp; Capabilities.</li>
<li class="has-line-data" data-line-start="33" data-line-end="35">Run the app on a compatible iOS device.</li>
</ol>
<h2 class="code-line" data-line-start=35 data-line-end=36 ><a id="Permissions_35"></a>Permissions</h2>
<p class="has-line-data" data-line-start="37" data-line-end="38">The app requests permission to read the above-mentioned health data. Users must grant access in the Health app under Settings &gt; Privacy &gt; Health.</p>
<h2 class="code-line" data-line-start=39 data-line-end=40 ><a id="Code_Snippet_39"></a>Code Snippet</h2>
<p class="has-line-data" data-line-start="41" data-line-end="42">The app requests permission to read health data using the following Swift code:</p>
<pre><code class="has-line-data" data-line-start="43" data-line-end="54" class="language-sh">var allDataTypes: Set&lt;HKQuantityType&gt; {
    <span class="hljs-built_in">let</span> types: [HKQuantityType] = [
        HKQuantityType.quantityType(<span class="hljs-keyword">for</span>Identifier: .stepCount),
        HKQuantityType.quantityType(<span class="hljs-keyword">for</span>Identifier: .heartRate),
        HKQuantityType.quantityType(<span class="hljs-keyword">for</span>Identifier: .distanceWalkingRunning),
        HKQuantityType.quantityType(<span class="hljs-keyword">for</span>Identifier: .bodyMass)
    ].compactMap { <span class="hljs-variable">$0</span> } // Remove any nil values
    
    <span class="hljs-built_in">return</span> Set(types)
}
</code></pre>
<h2 class="code-line" data-line-start=55 data-line-end=56 ><a id="License_55"></a>License</h2>
<p class="has-line-data" data-line-start="57" data-line-end="58">This project is open-source and available under the MIT License.</p>
<h2 class="code-line" data-line-start=59 data-line-end=60 ><a id="Author_59"></a>Author</h2>
<p class="has-line-data" data-line-start="61" data-line-end="62">Developed by Me.</p>
