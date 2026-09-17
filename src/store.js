window.Reel = (() => {
 const genres=['Adventure','Animation','Comedy','Drama','Mystery','Sci-Fi'];
 const movies=[
 {id:'arrival',title:'Arrival',year:2016,minutes:116,genres:['Sci-Fi','Drama','Mystery'],symbol:'◎',color:'#304954',description:'A linguist searches for meaning when mysterious visitors arrive on Earth.'},
 {id:'spiderverse',title:'Spider-Man: Into the Spider-Verse',year:2018,minutes:117,genres:['Animation','Adventure','Comedy'],symbol:'✳',color:'#733d70',description:'Miles Morales discovers that being a hero can take more than one form.'},
 {id:'knives',title:'Knives Out',year:2019,minutes:130,genres:['Mystery','Comedy','Drama'],symbol:'♜',color:'#5d5030',description:'An eccentric detective untangles a wealthy family’s very complicated secrets.'},
 {id:'paddington',title:'Paddington 2',year:2017,minutes:103,genres:['Comedy','Adventure'],symbol:'▧',color:'#a54d36',description:'A kindhearted bear and a missing book lead to an unexpectedly grand adventure.'},
 {id:'interstellar',title:'Interstellar',year:2014,minutes:169,genres:['Sci-Fi','Adventure','Drama'],symbol:'◉',color:'#32425e',description:'Explorers travel beyond our galaxy in search of a future for humanity.'},
 {id:'grand',title:'The Grand Budapest Hotel',year:2014,minutes:99,genres:['Comedy','Adventure'],symbol:'♙',color:'#94586f',description:'A hotel concierge and his young protégé get swept into a wonderfully odd caper.'},
 {id:'coco',title:'Coco',year:2017,minutes:105,genres:['Animation','Adventure'],symbol:'❋',color:'#8a472a',description:'An aspiring musician journeys through a colorful world of family and memory.'},
 {id:'martian',title:'The Martian',year:2015,minutes:144,genres:['Sci-Fi','Adventure'],symbol:'◌',color:'#94542e',description:'A stranded astronaut turns science and stubborn optimism into a survival plan.'},
 {id:'truman',title:'The Truman Show',year:1998,minutes:103,genres:['Drama','Comedy','Sci-Fi'],symbol:'◈',color:'#3e746b',description:'An ordinary man starts to question the extraordinary world built around him.'},
 {id:'zootopia',title:'Zootopia',year:2016,minutes:108,genres:['Animation','Comedy','Mystery'],symbol:'✧',color:'#596c3c',description:'An unlikely detective duo follows a mystery through a city of animals.'},
 {id:'inception',title:'Inception',year:2010,minutes:148,genres:['Sci-Fi','Mystery','Adventure'],symbol:'◇',color:'#425765',description:'A team enters the architecture of dreams for one last impossible job.'},
 {id:'soul',title:'Soul',year:2020,minutes:100,genres:['Animation','Comedy','Drama'],symbol:'♫',color:'#524e86',description:'A jazz musician discovers new meaning in the small moments of everyday life.'}
 ];
 const key='reelmatch-v1';
 const defaults=()=>({people:[{name:'Alex',genres:['Sci-Fi','Adventure'],max:150},{name:'Jordan',genres:['Comedy','Mystery'],max:150},{name:'Sam',genres:['Animation','Adventure'],max:150}],shortlist:[],votes:[null,null,null]});
 let state=defaults();
 try {const s=JSON.parse(localStorage.getItem(key));if(s && Array.isArray(s.people)&&s.people.length>=2&&s.people.length<=5&&s.people.every(p=>p&&typeof p.name==='string'&&Array.isArray(p.genres)&&p.genres.every(g=>genres.includes(g))&&[110,130,150,180].includes(p.max))&&Array.isArray(s.shortlist)&&s.shortlist.every(id=>movies.some(m=>m.id===id))&&Array.isArray(s.votes)&&s.votes.length===s.people.length&&s.votes.every(v=>v===null||s.shortlist.includes(v))) state=s;}catch(_){}
 const escape=v=>String(v).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
 function save(){let ok=true;try{localStorage.setItem(key,JSON.stringify(state));}catch(_){ok=false;}document.dispatchEvent(new Event('reel:change'));document.getElementById('notice').textContent=ok?'':'Storage unavailable: changes will only last for this session.';}
 function rank(){return movies.map(movie=>{const scores=state.people.map(p=>Math.round(movie.genres.filter(g=>p.genres.includes(g)).length/movie.genres.length*100));return {...movie,scores,score:Math.round(scores.reduce((a,b)=>a+b,0)/state.people.length),fits:state.people.every(p=>movie.minutes<=p.max)};}).sort((a,b)=>Number(b.fits)-Number(a.fits)||b.score-a.score||a.title.localeCompare(b.title));}
 return {state,genres,movies,escape,save,rank};
})();