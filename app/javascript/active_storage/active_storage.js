addEventListener("direct-upload:initialize", event => {
    const {target, detail} = event;
    const {id, file} = detail;
    target.insertAdjacentHTML("beforebegin", `
    <div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
      <div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div>
      <span class="direct-upload__filename">${file.name}</span>
    </div>
  `)
});

addEventListener("direct-upload:start", event => {
    const {id} = event.detail;
    let this_id = 'direct-upload-' + id;
    const element = document.getElementById(this_id);
    element.classList.remove("direct-upload--pending");
});

addEventListener("direct-upload:progress", event => {
    const {id, progress} = event.detail;
    let this_id = 'direct-upload-progress-' + id
    const progressElement = document.getElementById(this_id);
    progressElement.style.width = '${progress}%';
});

addEventListener("direct-upload:error", event => {
    event.preventDefault();
    console.log('Error:', event);
    const {id, error} = event.detail;
    let this_id = 'direct-upload-' + id;
    const element = document.getElementById(this_id);
    element.classList.add("direct-upload--error");
    element.setAttribute("title", error);
});

addEventListener("direct-upload:end", event => {
    const {id} = event.detail;
    let this_id = 'direct-upload-' + id;
    const element = document.getElementById(this_id);
    element.classList.add("direct-upload--complete");
});
